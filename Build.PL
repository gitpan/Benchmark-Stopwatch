use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name       => 'Benchmark::Stopwatch',
    license           => 'perl',
    dist_author       => 'Edmund von der Burg <evdb@ecclestoad.co.uk>',
    dist_version_from => 'lib/Benchmark/Stopwatch.pm',

    requires => {
        'Carp'        => 0,
        'Time::HiRes' => 0,
    },

    build_requires => {
        'Module::Build'    => 0,
        'Test::More'       => 0,
        'Test::LongString' => 0,
    },
);

$builder->create_build_script();
