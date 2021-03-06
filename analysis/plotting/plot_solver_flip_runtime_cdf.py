# Copyright (c) 2016, Ionel Gog

import csv
import gflags
import math
import matplotlib
matplotlib.use("agg")
import os, sys
import matplotlib.pyplot as plt
from utils import *

FLAGS = gflags.FLAGS
gflags.DEFINE_bool('paper_mode', False, 'Adjusts the size of the plots.')
gflags.DEFINE_bool('log_scale', True, 'Plot x axis on log scale.')
gflags.DEFINE_string('algorithm', 'relax', 'Plot for algorithm. Options: '
                     'relax | cost_scaling.')
gflags.DEFINE_string('trace_paths', '',
                     ', separated list of path to trace files.')
gflags.DEFINE_string('trace_labels', '',
                     ', separated list of labels to use for trace files.')
gflags.DEFINE_integer('number_runs_in_cost_scaling', 2,
                      'Number of initial cost scaling runs')


def plot_cdf(plot_file_name, cdf_vals, label_axis, labels, log_scale=False,
             bin_width=1000, unit='ms'):
    colors = ['y', 'b', 'g', 'c', 'm', 'y', 'k']
    if FLAGS.paper_mode:
        plt.figure(figsize=(3, 2))
        set_paper_rcs()
    else:
        plt.figure()
        set_rcs()

    max_cdf_val = 0
    max_perc90 = 0
    max_perc99 = 0
    index = 0
    for vals in cdf_vals:
        print "Statistics for %s" % (labels[index])
        avg = np.mean(vals)
        print "AVG: %f" % (avg)
        median = np.median(vals)
        print "MEDIAN: %f" % (median)
        min_val = np.min(vals)
        print "MIN: %ld" % (min_val)
        max_val = np.max(vals)
        max_cdf_val = max(max_val, max_cdf_val)
        print "MAX: %ld" % (max_val)
        stddev = np.std(vals)
        print "STDDEV: %f" % (stddev)
        print "PERCENTILES:"
        perc1 = np.percentile(vals, 1)
        print "  1st: %f" % (perc1)
        perc10 = np.percentile(vals, 10)
        print " 10th: %f" % (perc10)
        perc25 = np.percentile(vals, 25)
        print " 25th: %f" % (perc25)
        perc50 = np.percentile(vals, 50)
        print " 50th: %f" % (perc50)
        perc75 = np.percentile(vals, 75)
        print " 75th: %f" % (perc75)
        perc90 = np.percentile(vals, 90)
        max_perc90 = max(max_perc90, perc90)
        print " 90th: %f" % (perc90)
        perc99 = np.percentile(vals, 99)
        max_perc99 = max(max_perc99, perc99)
        print " 99th: %f" % (perc99)

        bin_range = max_val - min_val
        num_bins = bin_range / bin_width

        (n, bins, patches) = plt.hist(vals, bins=num_bins, log=False,
                                      normed=True, cumulative=True,
                                      histtype="step", color=colors[index])
        # hack to add line to legend
        plt.plot([-100], [-100], label=labels[index],
                 color=colors[index], linestyle='solid', lw=1.0)
        # hack to remove vertical bar
        patches[0].set_xy(patches[0].get_xy()[:-1])

        index += 1


    time_val = 1000
    if unit is 'ms':
        time_val = 1000 # 1 ms
    elif unit is 'sec':
        time_val = 1000 * 1000 # 1 sec
    else:
        print 'Error: unknown time unit'
        exit(1)
    to_time_unit = time_val
    plt.xlim(100000, max_cdf_val)

    if log_scale:
        plt.xscale("log")
        x_ticks = []
        # Start at 100 ms
        time_val = 100 * time_val
        while time_val <= max_cdf_val:
            x_ticks.append(time_val)
            time_val *= 10
        plt.xticks(x_ticks, [str(x / to_time_unit) for x in x_ticks])
    else:
        plt.xticks(range(0, max_cdf_val, 5000000),
                   [str(x / to_time_unit) for x in range(0, max_cdf_val, 5000000)])
    plt.ylim(0, 1.0)
    plt.yticks(np.arange(0.0, 1.01, 0.2),
               [str(x) for x in np.arange(0.0, 1.01, 0.2)])
    plt.ylabel('CDF of algorithm runtimes')
    plt.xlabel(label_axis)

    plt.legend(loc=4, frameon=False, handlelength=1.5, handletextpad=0.2)

    plt.savefig("%s.pdf" % plot_file_name,
                format="pdf", bbox_inches="tight")


def get_scheduler_runtimes(trace_path, column_index):
    # 0 timestamp
    # 1 solver runtime
    # 2 algorithm runtime
    # 3 total runtime (including Firmament)
    runtimes = []
    csv_file = open(trace_path + "/scheduler_events/scheduler_events.csv")
    csv_reader = csv.reader(csv_file)
    num_run = 0
    mod_res = 0
    if FLAGS.algorithm == 'relax':
        mod_res = 1
    elif FLAGS.algorithm == 'cost_scaling':
        mod_res = 0
    else:
        print 'Error: Unexpected algorithm'
    for row in csv_reader:
        num_run = num_run + 1
        timestamp = long(row[0])
        if num_run > FLAGS.number_runs_in_cost_scaling:
            if (num_run - FLAGS.number_runs_in_cost_scaling) % 2 == mod_res:
                runtimes.append(long(row[column_index]))

    csv_file.close()
    return runtimes


def main(argv):
    try:
        argv = FLAGS(argv)
    except gflags.FlagsError as e:
        print('%s\\nUsage: %s ARGS\\n%s' % (e, sys.argv[0], FLAGS))

    trace_paths = FLAGS.trace_paths.split(',')
    labels = FLAGS.trace_labels.split(',')
    sched_runtimes = []
    algo_runtimes = []
    sched_trace_labels = []
    algo_trace_labels = []
    trace_id = 0
    for trace_path in trace_paths:
        sched_runtime = get_scheduler_runtimes(trace_path, 1)
        algo_runtime = get_scheduler_runtimes(trace_path, 2)
        print "Number scheduler runs: %d" % (len(sched_runtime))
        sched_runtimes.append(sched_runtime)
        sched_trace_labels.append(labels[trace_id])
        # XXX(malte): hack to deal with cs2 not providing this info
        if algo_runtime[0] != 18446744073709551615:
          algo_runtimes.append(algo_runtime)
          algo_trace_labels.append(labels[trace_id])
        trace_id += 1

    plot_cdf('algorithm_runtimes_cdf', algo_runtimes, "Algorithm runtime [sec]",
             algo_trace_labels, log_scale=FLAGS.log_scale, bin_width=1000,
             unit='sec')


if __name__ == '__main__':
  main(sys.argv)
