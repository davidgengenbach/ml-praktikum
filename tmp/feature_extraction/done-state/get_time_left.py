#!/usr/bin/env python3
import datetime

IMG_COUNT = 170000

with open('counts.txt') as f:
    counts = [x.split(' ') for x in f.read().split('\n')]

def parse_count(count):
    if len(count) != 2:
        return None
    time = datetime.datetime.strptime(count[0], '%Y%m%d_%H%M%S')
    return (time, int(count[1]))

counts = [parse_count(count) for count in counts if parse_count(count) != None]
img_to_be_done = IMG_COUNT - counts[-1][1]

def get_rate(count_a, count_b):
	diff = (count_a[0] - count_b[0], count_a[1] - count_b[1])
	if diff[1] == 0:
		rate = 0
	else:
		rate = diff[0].total_seconds() / diff[1]
	
	return rate

def get_human_readable_eta(rate):
	seconds = img_to_be_done * rate
	return datetime.timedelta(seconds=seconds)

last_count = min(10, len(counts))

first = counts[0]
last = counts[-1]
total_rate = get_rate(last, first)

print("Total\t", str(get_human_readable_eta(total_rate)))
print("Last{}\t".format(last_count), str(get_human_readable_eta(get_rate(counts[-1], counts[-last_count]))))