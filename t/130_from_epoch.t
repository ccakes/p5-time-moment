#!perl
use strict;
use warnings;

use Test::More;
use t::Util    qw[throws_ok lives_ok];

BEGIN {
    use_ok('Time::Moment');
}

{
    my @tests = (
        [ -62135596800,         0, '0001-01-01T00:00:00Z'           ],
        [ -62135596800, 123456789, '0001-01-01T00:00:00.123456789Z' ],
        [ -62135596800, 123456000, '0001-01-01T00:00:00.123456Z'    ],
        [ -62135596800, 123000000, '0001-01-01T00:00:00.123Z'       ],
        [            0,         0, '1970-01-01T00:00:00Z'           ],
        [ 253402300799,         0, '9999-12-31T23:59:59Z'           ],
        [ 253402300799, 987654321, '9999-12-31T23:59:59.987654321Z' ],
        [ 253402300799, 987654000, '9999-12-31T23:59:59.987654Z'    ],
        [ 253402300799, 987000000, '9999-12-31T23:59:59.987Z'       ],
    );

    foreach my $test (@tests) {
        my ($secs, $nos, $string) = @$test;
        my $tm;
        {
            my $prefix = "from_epoch($secs, $nos)";
            lives_ok { $tm = Time::Moment->from_epoch($secs, $nos) } $prefix;
            is($tm->epoch,       $secs,   "$prefix->epoch");
            is($tm->nanosecond,  $nos,    "$prefix->nanosecond");
            is($tm->offset,      0,       "$prefix->offset");
            is($tm->to_string,   $string, "$prefix->to_string");
        }

        {
            my $prefix = "from_epoch($secs, nanosecond => $nos)";
            lives_ok { $tm = Time::Moment->from_epoch($secs, nanosecond => $nos) } $prefix;
            is($tm->epoch,       $secs,   "$prefix->epoch");
            is($tm->nanosecond,  $nos,    "$prefix->nanosecond");
            is($tm->offset,      0,       "$prefix->offset");
            is($tm->to_string,   $string, "$prefix->to_string");
        }
    }
}

{
    my @tests = (
        [ '1920-12-31T23:59:59Z',          -1546300801.0                ],
        [ '1920-12-31T23:59:59.000001Z',   -1546300800.999999046325684  ],
        [ '1920-12-31T23:59:59.000002Z',   -1546300800.999998092651367  ],
        [ '1920-12-31T23:59:59.000010Z',   -1546300800.999989986419678  ],
        [ '1920-12-31T23:59:59.000020Z',   -1546300800.999979972839355  ],
        [ '1920-12-31T23:59:59.000100Z',   -1546300800.999900102615356  ],
        [ '1920-12-31T23:59:59.000200Z',   -1546300800.999799966812134  ],
        [ '1920-12-31T23:59:59.001Z',      -1546300800.999000072479248  ],
        [ '1920-12-31T23:59:59.002Z',      -1546300800.997999906539917  ],
        [ '1920-12-31T23:59:59.010Z',      -1546300800.990000009536743  ],
        [ '1920-12-31T23:59:59.020Z',      -1546300800.980000019073486  ],
        [ '1920-12-31T23:59:59.100Z',      -1546300800.900000095367432  ],
        [ '1920-12-31T23:59:59.192Z',      -1546300800.808000087738037  ],
        [ '1920-12-31T23:59:59.192080Z',   -1546300800.807919979095459  ],
        [ '1920-12-31T23:59:59.192090Z',   -1546300800.807909965515137  ],
        [ '1920-12-31T23:59:59.192098Z',   -1546300800.807902097702026  ],
        [ '1920-12-31T23:59:59.192099Z',   -1546300800.807900905609131  ],
        [ '1920-12-31T23:59:59.200Z',      -1546300800.799999952316284  ],
        [ '1920-12-31T23:59:59.300Z',      -1546300800.700000047683716  ],
        [ '1920-12-31T23:59:59.400Z',      -1546300800.599999904632568  ],
        [ '1920-12-31T23:59:59.419200Z',   -1546300800.58080005645752   ],
        [ '1920-12-31T23:59:59.419209Z',   -1546300800.580790996551514  ],
        [ '1920-12-31T23:59:59.490Z',      -1546300800.509999990463257  ],
        [ '1920-12-31T23:59:59.499Z',      -1546300800.500999927520752  ],
        [ '1920-12-31T23:59:59.499900Z',   -1546300800.500099897384644  ],
        [ '1920-12-31T23:59:59.500Z',      -1546300800.5                ],
        [ '1920-12-31T23:59:59.500001Z',   -1546300800.499999046325684  ],
        [ '1920-12-31T23:59:59.500010Z',   -1546300800.499989986419678  ],
        [ '1920-12-31T23:59:59.500100Z',   -1546300800.499900102615356  ],
        [ '1920-12-31T23:59:59.501Z',      -1546300800.499000072479248  ],
        [ '1920-12-31T23:59:59.510Z',      -1546300800.490000009536743  ],
        [ '1920-12-31T23:59:59.600Z',      -1546300800.400000095367432  ],
        [ '1920-12-31T23:59:59.700Z',      -1546300800.299999952316284  ],
        [ '1920-12-31T23:59:59.800Z',      -1546300800.200000047683716  ],
        [ '1920-12-31T23:59:59.900Z',      -1546300800.099999904632568  ],
        [ '1920-12-31T23:59:59.980Z',      -1546300800.019999980926514  ],
        [ '1920-12-31T23:59:59.990Z',      -1546300800.009999990463257  ],
        [ '1920-12-31T23:59:59.998Z',      -1546300800.002000093460083  ],
        [ '1920-12-31T23:59:59.999Z',      -1546300800.000999927520752  ],
        [ '1920-12-31T23:59:59.999800Z',   -1546300800.000200033187866  ],
        [ '1969-12-31T23:59:58Z',          -2.0                         ],
        [ '1969-12-31T23:59:58.500Z',      -1.5                         ],
        [ '1969-12-31T23:59:58.800Z',      -1.2                         ],
        [ '1969-12-31T23:59:58.900Z',      -1.1                         ],
        [ '1969-12-31T23:59:58.980Z',      -1.02                        ],
        [ '1969-12-31T23:59:58.990Z',      -1.01                        ],
        [ '1969-12-31T23:59:58.998Z',      -1.002                       ],
        [ '1969-12-31T23:59:58.999Z',      -1.001                       ],
        [ '1969-12-31T23:59:58.999800Z',   -1.0002                      ],
        [ '1969-12-31T23:59:58.999900Z',   -1.0001                      ],
        [ '1969-12-31T23:59:58.999980Z',   -1.00002                     ],
        [ '1969-12-31T23:59:58.999990Z',   -1.00001                     ],
        [ '1969-12-31T23:59:58.999998Z',   -1.000002                    ],
        [ '1969-12-31T23:59:58.999999Z',   -1.000001                    ],
        [ '1969-12-31T23:59:59Z',          -1.0                         ],
        [ '1969-12-31T23:59:59.000001Z',   -0.999999                    ],
        [ '1969-12-31T23:59:59.000002Z',   -0.999998                    ],
        [ '1969-12-31T23:59:59.000010Z',   -0.99999                     ],
        [ '1969-12-31T23:59:59.000020Z',   -0.99998                     ],
        [ '1969-12-31T23:59:59.000100Z',   -0.9999                      ],
        [ '1969-12-31T23:59:59.000200Z',   -0.9998                      ],
        [ '1969-12-31T23:59:59.001Z',      -0.999                       ],
        [ '1969-12-31T23:59:59.002Z',      -0.998                       ],
        [ '1969-12-31T23:59:59.010Z',      -0.99                        ],
        [ '1969-12-31T23:59:59.020Z',      -0.98                        ],
        [ '1969-12-31T23:59:59.100Z',      -0.9                         ],
        [ '1969-12-31T23:59:59.200Z',      -0.8                         ],
        [ '1969-12-31T23:59:59.300Z',      -0.7                         ],
        [ '1969-12-31T23:59:59.400Z',      -0.6                         ],
        [ '1969-12-31T23:59:59.490Z',      -0.51                        ],
        [ '1969-12-31T23:59:59.499Z',      -0.501                       ],
        [ '1969-12-31T23:59:59.499900Z',   -0.5001                      ],
        [ '1969-12-31T23:59:59.499990Z',   -0.50001                     ],
        [ '1969-12-31T23:59:59.499999Z',   -0.500001                    ],
        [ '1969-12-31T23:59:59.500Z',      -0.5                         ],
        [ '1969-12-31T23:59:59.500001Z',   -0.499999                    ],
        [ '1969-12-31T23:59:59.500010Z',   -0.49999                     ],
        [ '1969-12-31T23:59:59.500100Z',   -0.4999                      ],
        [ '1969-12-31T23:59:59.501Z',      -0.499                       ],
        [ '1969-12-31T23:59:59.510Z',      -0.49                        ],
        [ '1969-12-31T23:59:59.600Z',      -0.4                         ],
        [ '1969-12-31T23:59:59.700Z',      -0.3                         ],
        [ '1969-12-31T23:59:59.800Z',      -0.2                         ],
        [ '1969-12-31T23:59:59.900Z',      -0.1                         ],
        [ '1969-12-31T23:59:59.980Z',      -0.02                        ],
        [ '1969-12-31T23:59:59.990Z',      -0.01                        ],
        [ '1969-12-31T23:59:59.998Z',      -0.002                       ],
        [ '1969-12-31T23:59:59.999Z',      -0.001                       ],
        [ '1969-12-31T23:59:59.999800Z',   -0.0002                      ],
        [ '1969-12-31T23:59:59.999900Z',   -0.0001                      ],
        [ '1969-12-31T23:59:59.999980Z',   -0.00002                     ],
        [ '1969-12-31T23:59:59.999990Z',   -0.00001                     ],
        [ '1969-12-31T23:59:59.999998Z',   -0.000002                    ],
        [ '1969-12-31T23:59:59.999999Z',   -0.000001                    ],
        [ '1970-01-01T00:00:00Z',          0.0                          ],
        [ '1970-01-01T00:00:00.000001Z',   0.000001                     ],
        [ '1970-01-01T00:00:00.000002Z',   0.000002                     ],
        [ '1970-01-01T00:00:00.000010Z',   0.00001                      ],
        [ '1970-01-01T00:00:00.000020Z',   0.00002                      ],
        [ '1970-01-01T00:00:00.000100Z',   0.0001                       ],
        [ '1970-01-01T00:00:00.000200Z',   0.0002                       ],
        [ '1970-01-01T00:00:00.001Z',      0.001                        ],
        [ '1970-01-01T00:00:00.002Z',      0.002                        ],
        [ '1970-01-01T00:00:00.010Z',      0.01                         ],
        [ '1970-01-01T00:00:00.020Z',      0.02                         ],
        [ '1970-01-01T00:00:00.100Z',      0.1                          ],
        [ '1970-01-01T00:00:00.200Z',      0.2                          ],
        [ '1970-01-01T00:00:00.300Z',      0.3                          ],
        [ '1970-01-01T00:00:00.400Z',      0.4                          ],
        [ '1970-01-01T00:00:00.490Z',      0.49                         ],
        [ '1970-01-01T00:00:00.499Z',      0.499                        ],
        [ '1970-01-01T00:00:00.499900Z',   0.4999                       ],
        [ '1970-01-01T00:00:00.499990Z',   0.49999                      ],
        [ '1970-01-01T00:00:00.499999Z',   0.499999                     ],
        [ '1970-01-01T00:00:00.500Z',      0.5                          ],
        [ '1970-01-01T00:00:00.500001Z',   0.500001                     ],
        [ '1970-01-01T00:00:00.500010Z',   0.50001                      ],
        [ '1970-01-01T00:00:00.500100Z',   0.5001                       ],
        [ '1970-01-01T00:00:00.501Z',      0.501                        ],
        [ '1970-01-01T00:00:00.510Z',      0.51                         ],
        [ '1970-01-01T00:00:00.600Z',      0.6                          ],
        [ '1970-01-01T00:00:00.700Z',      0.7                          ],
        [ '1970-01-01T00:00:00.800Z',      0.8                          ],
        [ '1970-01-01T00:00:00.900Z',      0.9                          ],
        [ '1970-01-01T00:00:00.980Z',      0.98                         ],
        [ '1970-01-01T00:00:00.990Z',      0.99                         ],
        [ '1970-01-01T00:00:00.999800Z',   0.9998                       ],
        [ '1970-01-01T00:00:00.999900Z',   0.9999                       ],
        [ '1970-01-01T00:00:00.999980Z',   0.99998                      ],
        [ '1970-01-01T00:00:00.999990Z',   0.99999                      ],
        [ '1970-01-01T00:00:00.999998Z',   0.999998                     ],
        [ '1970-01-01T00:00:00.999999Z',   0.999999                     ],
        [ '1970-01-01T00:00:01Z',          1.0                          ],
        [ '1970-01-01T00:00:01.000001Z',   1.000001                     ],
        [ '1970-01-01T00:00:01.000002Z',   1.000002                     ],
        [ '1970-01-01T00:00:01.000010Z',   1.00001                      ],
        [ '1970-01-01T00:00:01.000020Z',   1.00002                      ],
        [ '1970-01-01T00:00:01.000100Z',   1.0001                       ],
        [ '1970-01-01T00:00:01.000200Z',   1.0002                       ],
        [ '1970-01-01T00:00:01.001Z',      1.001                        ],
        [ '1970-01-01T00:00:01.002Z',      1.002                        ],
        [ '1970-01-01T00:00:01.010Z',      1.01                         ],
        [ '1970-01-01T00:00:01.020Z',      1.02                         ],
        [ '1970-01-01T00:00:01.100Z',      1.1                          ],
        [ '1970-01-01T00:00:01.200Z',      1.2                          ],
        [ '2020-12-31T23:59:59Z',          1609459199.0                 ],
        [ '2020-12-31T23:59:59.000001Z',   1609459199.000000953674316   ],
        [ '2020-12-31T23:59:59.000002Z',   1609459199.000001907348633   ],
        [ '2020-12-31T23:59:59.000010Z',   1609459199.000010013580322   ],
        [ '2020-12-31T23:59:59.000020Z',   1609459199.000020027160645   ],
        [ '2020-12-31T23:59:59.000100Z',   1609459199.000099897384644   ],
        [ '2020-12-31T23:59:59.000200Z',   1609459199.000200033187866   ],
        [ '2020-12-31T23:59:59.001Z',      1609459199.000999927520752   ],
        [ '2020-12-31T23:59:59.002Z',      1609459199.002000093460083   ],
        [ '2020-12-31T23:59:59.010Z',      1609459199.009999990463257   ],
        [ '2020-12-31T23:59:59.020Z',      1609459199.019999980926514   ],
        [ '2020-12-31T23:59:59.100Z',      1609459199.099999904632568   ],
        [ '2020-12-31T23:59:59.200Z',      1609459199.200000047683716   ],
        [ '2020-12-31T23:59:59.202Z',      1609459199.20199990272522    ],
        [ '2020-12-31T23:59:59.202080Z',   1609459199.202080011367798   ],
        [ '2020-12-31T23:59:59.202090Z',   1609459199.20209002494812    ],
        [ '2020-12-31T23:59:59.202098Z',   1609459199.20209789276123    ],
        [ '2020-12-31T23:59:59.202099Z',   1609459199.202099084854126   ],
        [ '2020-12-31T23:59:59.300Z',      1609459199.299999952316284   ],
        [ '2020-12-31T23:59:59.400Z',      1609459199.400000095367432   ],
        [ '2020-12-31T23:59:59.420200Z',   1609459199.420200109481812   ],
        [ '2020-12-31T23:59:59.420209Z',   1609459199.420208930969238   ],
        [ '2020-12-31T23:59:59.490Z',      1609459199.490000009536743   ],
        [ '2020-12-31T23:59:59.499Z',      1609459199.499000072479248   ],
        [ '2020-12-31T23:59:59.499900Z',   1609459199.499900102615356   ],
        [ '2020-12-31T23:59:59.500Z',      1609459199.5                 ],
        [ '2020-12-31T23:59:59.500001Z',   1609459199.500000953674316   ],
        [ '2020-12-31T23:59:59.500010Z',   1609459199.500010013580322   ],
        [ '2020-12-31T23:59:59.500100Z',   1609459199.500099897384644   ],
        [ '2020-12-31T23:59:59.501Z',      1609459199.500999927520752   ],
        [ '2020-12-31T23:59:59.510Z',      1609459199.509999990463257   ],
        [ '2020-12-31T23:59:59.600Z',      1609459199.599999904632568   ],
        [ '2020-12-31T23:59:59.700Z',      1609459199.700000047683716   ],
        [ '2020-12-31T23:59:59.800Z',      1609459199.799999952316284   ],
        [ '2020-12-31T23:59:59.900Z',      1609459199.900000095367432   ],
        [ '2020-12-31T23:59:59.980Z',      1609459199.980000019073486   ],
        [ '2020-12-31T23:59:59.990Z',      1609459199.990000009536743   ],
        [ '2020-12-31T23:59:59.998Z',      1609459199.997999906539917   ],
        [ '2020-12-31T23:59:59.999Z',      1609459199.999000072479248   ],
        [ '2020-12-31T23:59:59.999800Z',   1609459199.999799966812134   ],
    );

    foreach my $test (@tests) {
        my ($string, $epoch) = @$test;

        {
            my $tm = Time::Moment->from_epoch($epoch);
            is($tm->to_string, $string, "from_epoch($epoch)");
        }

        {
            my $tm = Time::Moment->from_epoch($epoch, precision => 6);
            is($tm->to_string, $string, "from_epoch($epoch, precision => 6)");
        }
    }
}


{
    my @tests = (
        [ '1920-12-31T23:59:59.499Z',      -1546300800.500999927520752  ],
        [ '1920-12-31T23:59:59.999Z',      -1546300800.000999927520752  ],
        [ '1969-12-31T23:59:58Z',          -2.0                         ],
        [ '1969-12-31T23:59:58.500Z',      -1.5                         ],
        [ '1969-12-31T23:59:58.800Z',      -1.2                         ],
        [ '1969-12-31T23:59:58.900Z',      -1.1                         ],
        [ '1969-12-31T23:59:58.980Z',      -1.02                        ],
        [ '1969-12-31T23:59:58.990Z',      -1.01                        ],
        [ '1969-12-31T23:59:58.998Z',      -1.002                       ],
        [ '1969-12-31T23:59:58.999Z',      -1.001                       ],
        [ '1969-12-31T23:59:59Z',          -1.0                         ],
        [ '1970-01-01T00:00:00Z',          0.0                          ],
        [ '1970-01-01T00:00:00.500Z',      0.5                          ],
        [ '1970-01-01T00:00:00.501Z',      0.501                        ],
        [ '1970-01-01T00:00:00.510Z',      0.51                         ],
        [ '1970-01-01T00:00:00.600Z',      0.6                          ],
        [ '1970-01-01T00:00:00.700Z',      0.7                          ],
        [ '1970-01-01T00:00:00.800Z',      0.8                          ],
        [ '1970-01-01T00:00:00.900Z',      0.9                          ],
        [ '1970-01-01T00:00:00.980Z',      0.98                         ],
        [ '1970-01-01T00:00:00.990Z',      0.99                         ],
        [ '1970-01-01T00:00:00.999Z',      0.999                        ],
        [ '2020-12-31T23:59:59.499Z',      1609459199.499000072479248   ],
        [ '2020-12-31T23:59:59.999Z',      1609459199.999000072479248   ],
    );

    foreach my $test (@tests) {
        my ($string, $epoch) = @$test;

        my $tm = Time::Moment->from_epoch($epoch, precision => 3);
        is($tm->to_string, $string, "from_epoch($epoch, precision => 3)");
    }
}

done_testing();
