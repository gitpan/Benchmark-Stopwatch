use strict;
use warnings;

use Test::More 'no_plan';

use Time::HiRes;
use_ok 'Benchmark::Stopwatch';

my $sw = Benchmark::Stopwatch->new;
isa_ok $sw, 'Benchmark::Stopwatch';

my $start_pre = Time::HiRes::time;
$sw->start;
my $start_post = Time::HiRes::time;

# Twiddle thumbs....
Time::HiRes::time for 1 .. 100;

my $min = Time::HiRes::time - $start_post;
$sw->stop;
my $max = Time::HiRes::time - $start_pre;

ok $sw->total_time > $min, "\$sw->total is more than min";
ok $sw->total_time < $max, "\$sw->total is less than max";

# use Data::Dumper;
# 
# warn Dumper {
#     total => $sw->total,
#     min   => $min,
#     max   => $max,
# };
