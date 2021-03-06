#!/usr/bin/python
# -*- coding: utf-8 -*-
import csv
import datetime
import dateutil.parser
import gflags
import math
import os, sys, re, json
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
from utils import *
from process_synthetic_experiments import *
from matplotlib import pylab
from scipy.stats import scoreatpercentile
import process_mesos_masterlog
from box_and_whisker import *


FLAGS = gflags.FLAGS
gflags.DEFINE_integer('num_files_to_process', 1,
                      'The number of trace files to process.')
gflags.DEFINE_bool('paper_mode', False, 'Adjusts the size of the plots.')
gflags.DEFINE_string('trace_paths', '',
                     ', separated list of path to trace files.')
gflags.DEFINE_string('trace_labels', '',
                     ', separated list of labels to use for trace files.')
gflags.DEFINE_string('ideal_runtimes_path', '',
                     'path the the file containing the ideal runtimes.')
gflags.DEFINE_string('docker_results_file', '',
                     'path to the file containing Docker results.')
gflags.DEFINE_string('kubernetes_results_file', '',
                     'path to the file containing Kubernetes results.')
gflags.DEFINE_string('mesos_log_file', '',
                     'path to the file containing Mesos master log.')
gflags.DEFINE_string('sparrow_results_file', '',
                     'path to the file containing Sparrow results.')


SUBMIT_EVENT = 0
SCHEDULE_EVENT = 1
EVICT_EVENT = 2
FINISH_EVENT = 4

def get_ideal_runtimes(file_path):
    runtime_file = open(file_path)
    runtimes = []
    for line in runtime_file.readlines():
        vals = line.split(':')
        runtimes.append(long(vals[0]) * 60000000 + long(float(vals[1]) * 1000000))
    runtime_file.close()
    return runtimes


def get_scheduling_delays(trace_path):
    delays = []
    task_submit_time = {}
    tasks_submitted = set([])
    task_scheduled = {}
    tasks_on_machine = {}

    blacklisted_tasks = set([])
    try:
        csv_file = open(trace_path + "/blacklisted_tasks.csv")
        csv_reader = csv.reader(csv_file)
        for row in csv_reader:
            task_id = long(row[0])
            blacklisted_tasks.add(task_id)
        csv_file.close()
    except IOError:
        print 'No blacklisted_tasks file'

    for num_file in range(0, FLAGS.num_files_to_process, 1):
        csv_file = open(trace_path + "/task_events/part-" +
                        '{:05}'.format(num_file) + "-of-00500.csv")
        csv_reader = csv.reader(csv_file)
        for row in csv_reader:
            timestamp = long(row[0])
            task_id = (long(row[2]), long(row[3]))
            if long(row[3]) in blacklisted_tasks:
                continue
            machine = row[4]
            event_type = int(row[5])
            if event_type == SUBMIT_EVENT:
                tasks_submitted.add(task_id)
                task_submit_time[task_id] = timestamp
            elif event_type == SCHEDULE_EVENT:
                task_scheduled[task_id] = machine
                if machine in tasks_on_machine:
                    tasks_on_machine[machine] = tasks_on_machine[machine] + 1
                else:
                    tasks_on_machine[machine] = 1
                if tasks_on_machine[machine] > 2:
                    print "MACHINE", machine, "has", tasks_on_machine[machine]
            elif event_type == FINISH_EVENT:
                machine = task_scheduled[task_id]
                tasks_on_machine[machine] = tasks_on_machine[machine] - 1
                if task_id in task_submit_time:
                    submit_time = task_submit_time[task_id]
                    delays.append(timestamp - submit_time)
                    if timestamp - submit_time > 30000000:
                        print task_id
                else:
                    print ("Error: schedule event before submit event for task "
                           "(%s, %s)" % (row[2], row[3]))
                    exit(1)
        csv_file.close()
    print trace_path, 'tasks submitted:', len(tasks_submitted)
    return delays


def plot_task_response_times(runtimes, labels):
    colors = ['y', 'y', 'r', 'c', 'k', 'g', 'c', 'm']
    if FLAGS.paper_mode:
        plt.figure(figsize=(3.33, 2.22))
        set_paper_rcs()
    else:
        plt.figure()
        set_rcs()

    ax = plt.gca()
    bp = percentile_box_plot(ax, runtimes, color=colors)

    #plt.errorbar(range(1, len(setups) + 1), [np.mean(x) for x in runtimes],
    #             yerr=[np.std(x) for x in runtimes], marker="x")
    plt.xlim(0.5, len(labels) + 0.5)
    plt.ylim(ymin=0,ymax=240)
    plt.xticks(range(1, len(labels) + 1), labels, rotation=30, ha='right')
    plt.yticks(range(0, 240000001, 20000000), range(0, 241, 20))
    plt.ylabel("Task response time [sec]")
    plt.savefig("net_task_duration_box_whiskers.pdf",
                format="pdf", bbox_inches="tight")



def main(argv):
    try:
        argv = FLAGS(argv)
    except gflags.FlagsError as e:
        print('%s\\nUsage: %s ARGS\\n%s' % (e, sys.argv[0], FLAGS))

    trace_paths = FLAGS.trace_paths.split(',')
    labels = FLAGS.trace_labels.split(',')
    delays = []
    delays.append(get_ideal_runtimes(FLAGS.ideal_runtimes_path))

    for trace_path in trace_paths:
        trace_delays = get_scheduling_delays(trace_path)
        print 'Number of tasks: ', len(trace_delays)
        delays.append(trace_delays)

    if FLAGS.docker_results_file != '':
        docker_file = open(FLAGS.docker_results_file)
        csv_reader = csv.reader(docker_file)
        docker_runtimes = []
        for row in csv_reader:
            docker_runtimes.append(long(row[0]))
        print 'Number of Docker tasks: ', len(docker_runtimes)
        delays.append(docker_runtimes)
        labels.append('Docker SwarmKit')
        docker_file.close()

    if FLAGS.kubernetes_results_file != '':
        k8s_file = open(FLAGS.kubernetes_results_file)
        csv_reader = csv.reader(k8s_file)
        k8s_runtimes = []
        for row in csv_reader:
            created = dateutil.parser.parse(row[0])
            created_time = int(created.strftime("%s")) * 1000000 + created.microsecond
            finished = dateutil.parser.parse(row[2])
            finished_time = int(finished.strftime("%s")) * 1000000 + finished.microsecond
            k8s_runtimes.append(finished_time - created_time)
        print 'Number of Kubernetes tasks: ', len(k8s_runtimes)
        delays.append(k8s_runtimes)
        labels.append('Kubernetes')
        k8s_file.close()

    if FLAGS.sparrow_results_file != '':
        sparrow_file = open(FLAGS.sparrow_results_file)
        csv_reader = csv.reader(sparrow_file)
        sparrow_runtimes = []
        for row in csv_reader:
            sparrow_runtimes.append(long(row[0]))
        print 'Number of Sparrow tasks: ', len(sparrow_runtimes)
        delays.append(sparrow_runtimes)
        labels.append('Sparrow')
        sparrow_file.close()

    if FLAGS.mesos_log_file != '':
        raw_runtimes, raw_waittimes = process_mesos_masterlog.parse_master_log(FLAGS.mesos_log_file)
        mesos_response = []
        for task, runtime in raw_runtimes.iteritems():
            mesos_response.append(int((runtime + raw_waittimes[task]) * 1000000))
#        runtimes_in_sec = raw_runtimes.values()
#        mesos_runtimes = []
#        for runtime in runtimes_in_sec:
#            mesos_runtimes.append(int(runtime * 1000000))
        delays.append(mesos_response)
        labels.append('Mesos')


    plot_task_response_times(delays, labels)

if __name__ == '__main__':
  main(sys.argv)
