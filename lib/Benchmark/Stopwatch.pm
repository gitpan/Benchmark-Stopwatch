use strict;
use warnings;

package Benchmark::Stopwatch;

our $VERSION = '0.01';

use Time::HiRes;

=head1 NAME

Benchmark::Stopwatch - simple timing of stages of your code.

=head1 SYNOPSIS

    use Benchmark::Stopwatch;
    my $stopwatch = Benchmark::Stopwatch->new->start;

    # ... code that reads from database ...
    $stopwatch->lap('read from database');

    # ... code that writes to disk ...
    $stopwatch->lap('write to disk');

    print $stopwatch->stop->summary;

    # NAME                        TIME        CUMULATIVE      PERCENTAGE
    #  read from database          0.123       0.123           34.462%
    #  write to disk               0.234       0.357           65.530%
    #  _stop_                      0.000       0.357           0.008%

=head1 DESCRIPTION

The other benchmark modules provide excellent timing for specific parts of
your code. This module aims to allow you to easily time the progression of
your code.

The stopwatch analogy is that at some point you get a C<new> stopwatch and
C<start> timing. Then you note certain events using C<lap>. Finally you
C<stop> the watch and then print out a C<summary>.

The summary shows all the events in order, what time they occured at, how long
since the last lap and the percentage of the total time. Hopefully this will
give you a good idea of where your code is spending most of its time.

The times are all wallclock times in fractional seconds.

That's it.

=head1 METHODS

=head2 new

    my $stopwatch = Benchmark::Stopwatch->new;
    
Creates a new stopwatch.

=cut

sub new {
    my $class = shift;
    my $self  = {};

    $self->{events} = [];
    $self->{_time}  = sub { Time::HiRes::time() };

    return bless $self, $class;
}

=head2 start

    $stopwatch = $stopwatch->start;

Starts the stopwatch. Returns a reference to the stopwatch so that you can
chain.

=cut

sub start {
    my $self = shift;
    $self->{start} = $self->time;
    return $self;
}

=head2 lap

    $stopwatch = $stopwatch->lap( 'name of event' );

Notes down the time at which an event occurs. This event will later appear in
the summary.

=cut

sub lap {
    my $self = shift;
    my $name = shift;
    my $time = $self->time;

    push @{ $self->{events} }, { name => $name, time => $time };
    return $self;
}

=head2 stop

    $stopwatch = $stopwatch->stop;

Stops the stopwatch. Returns a reference to the stopwatch so you can chain.

=cut

sub stop {
    my $self = shift;
    $self->{stop} = $self->time;
    return $self;
}

=head2 total_time

    my $time_in_seconds = $stopwatch->total_time;

Returns the time that the stopwatch ran for in fractional seconds.

=cut

sub total_time {
    my $self = shift;
    return $self->{stop} - $self->{start};
}

=head2 summary

    my $summary_text = $stopwatch->summary;

Returns text summarizing the events that occured. Example output from a script
that fetches the homepages of the web's five busiest sites and times how long
each took.

 NAME                        TIME        CUMULATIVE      PERCENTAGE
  http://www.yahoo.com/       3.892       3.892           22.399%
  http://www.google.com/      3.259       7.152           18.758%
  http://www.msn.com/         8.412       15.564          48.411%
  http://www.myspace.com/     0.532       16.096          3.062%
  http://www.ebay.com/        1.281       17.377          7.370%
  _stop_                      0.000       17.377          0.000%

The final entry C<_stop_> is when the stop watch was stopped.

=cut

sub summary {
    my $self          = shift;
    my $out           = '';
    my $header_format = "%-27.26s %-11s %-15s %s\n";
    my $result_format = " %-27.26s %-11.3f %-15.3f %.3f%%\n";
    my $prev_time     = $self->{start};

    push @{ $self->{events} }, { name => '_stop_', time => $self->{stop} };

    $out .= sprintf $header_format, qw( NAME TIME CUMULATIVE PERCENTAGE);

    foreach my $event ( @{ $self->{events} } ) {

        my $duration   = $event->{time} - $prev_time;
        my $cumulative = $event->{time} - $self->{start};
        my $percentage = ( $duration / $self->total_time ) * 100;

        $out .= sprintf $result_format,    #
          $event->{name},                  #
          $duration,                       #
          $cumulative,                     #
          $percentage;

        $prev_time = $event->{time};
    }

    pop @{ $self->{events} };
    return $out;
}

sub time {
    &{ $_[0]{_time} };
}

=head1 AUTHOR

Edmund von der Burg C< <evdb@ecclestoad.co.uk> >

http://www.ecclestoad.co.uk

=head1 COPYRIGHT

Copyright (C) 2006 Edmund von der Burg. All rights reserved.

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut

1;
