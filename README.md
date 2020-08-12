# bashbox
Draws box outlines and merges the drawn characters to maintain clean lines (this is a unicode mapping test).

This code doesn't need any elevated privileges and is really a demonstration of unicode character mapping for a much more abitious project I'm working on.

Summary - Basically draws stuff like this randomly on your terminal before sarting again after a while.



             │           │         │┌┼┐                              │     │   │ ┌──┤    │ │                   ┌───────┐
             │ ┌────┬────┼┬───────┐││││                              │     │   │ │  │    │ │                   │       │
             │ │    │    ││  ┌────┼┤└┼┴┐────────────                 ├─────┼───┘ │  │    │ │   ┌─────────┐     │       │
             │ │    │    ││  │    ││ │ │                             │     │     │  │ ┌──┼─┼┐ ┌┼─────────┼────┐│       │
     ┌───────┼─┼─┬──┴────┼┼┬─┴────┴┤ │ │                             │     │     │  │ │ ┌┤ ││ ││         │    │└───────┘
     └───────┼─┼─┴───────┼┼┘       │ │ │                                   │     │  │ │ ││ ││ └┼────────┬┼────┴─────┐
     ┌───────┼─┼────────┐││        ├─┼─┼────────┐                          ├─┐   │  │ │ ││ ││  │        ││   ┌──┬──┬┼──┐
     └───────┼─┼─────┬──┴┼┼────┐   │ │ │        │                          │ │   │  │ └─┼┼─┼┘  │        ││   │  │  ││  │
    ┌────┐   │ │     │ ┌─┼┼────┼─┬─┼─┼─┼┐       │                     ┌────┼─┼┐ ┌┴─┬┴───┼┼─┘   │        └┼───┴──┼──┴┴──┼┐
    │    │   │ │     │ │ ││    │ │ │ │ ││       │                     └┬───┼─┼┴─┼──┼────┼┼─────│         │      │      ││
    └────┘   │ │     │ │ ││    │ │ │ │ ││       │          ┌───────────┼──┐│ │  │  │    ││     │         │     ┌┼───┐  ││
             │ │     │ │ ││    │ │ │ │ ││   ┌───┼──────────┴───┬───────┼──┘└─┘  │  │    ││     │         │     ││   │  ││
 ┌──────┐    │ │     │ │ ││    │ │ │ │ ││   │   │              │       │   ┌──┐ │  │    ││     │         │     ││   │  ││
 │      │    │ └─────┼─┼─┼┘    │ │ ├─┤ ││   │   │     ┌────────┼──┐    │  ┌┼──┼─┼──┼─┐  ││     │         │     ││   │  ││
 │      │    └───────┴─┼─┴─────┤ │ │ │ ││   └───┼─────┼───┼────┘  │    │  ││  │ │  │ │  ││     │         │     ││   │  ││
 │      │              │       │ │ └─┼┬┼┼───────┤     │   │       │    │  ││  │ │  │ │  ││     │         │     │├───┼──┼┘
 │      │              │       │ │   ││││       │     │           │    │┌─┼┼──┼─┼─┐│ │  ││     │         │  ┌──┼┼─┬─┼──┼─
 │      │     ┌────┐   ├───────┼─┼───┤└┼┼───────┘     │           │ │  ││ ││  │ │┌┼┼─┼──┼┼─────┼───┐ ┌───┼──┼──┼┼─┼─┼┐ ││
 │      │ ┌───┼────┤   │       │ │   │ ││             │           │┌┼──┼┼─┼┴──┴─┤│││ │  ││     │   │ │   │  └──┼┼─┘ ││ ││
 │      │ ├───┼────┼┐  │       │ │   │ ││   ┌┐        │           │││  │├─┼─────┼┼┼┼┐│  ││     │   │ │   │     ││   ││ ││
 │┌─────┼─┼─┐ └────┤│  │       │ │   └─┘│   ││        └───────────┘││  ││ │     ││││││  ││     └───┼─┼───┘┌────┼┼───┼┼─┼┤
 ││     │ │ │      ││  │       │ │      │   ├┼───────┬──┬────────┐ ││  ││ │     ││││││  ││         │ │    │    ││   ││ ││
 │└─────┼─┼─┘      ││  │       │ └──────┘   ││       │  │        │ └┼──┼┼─┼─────┼┼┼┼┘│  ├┘         │ │    │    └┼───┴┼─┘│
 │      │ └────────┴┘  └───────┘            ├┘       │  │        │  │  └┼─┼─────┴┼┼┴─┼──┘          │ │    │     └────┼───
 └──────┘                                   │        │  │        │  │   │ │      ││  │             │ │    │          │  │
                                            │        │  │        │  │   │ │      ││  │             │ │    │          │  │
                                            │        └──┼────────┘  │   │ │      ││  │             │ │    │          │  │
                                            │           │           │   │ └──────┴┼──┴─────────────┘ │    └──────────┼───
                                            └───────────┘           │   │         │                  └───────────────┘
                                                                        └─────────┘
