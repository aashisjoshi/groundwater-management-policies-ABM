extensions [
  profiler  ; for efficient coding
  stats
]

globals [
  year-count
  peak-monthly-rainfall
  monthly-rainfall
  starting-groundwater-volume
  groundwater-volume
  municipal-water-supply-available
  rainfall-percolated-to-groundwater
  welfare-sufficiency-threshold
  ; community-consumption-restraint
  ticks-per-time-cycle
  groundwater-supply-longevity
  base-RHS-capacity
  starting-GWW-cost
  GWW-cost
  base-RHS-cost
  GWW-lifetime
  RHS-lifetime
  supplementing-system-last-installed-at
  total-tax-collected-this-tick
  total-tax-collected-record
  tax-funds-available-this-tick
  total-groundwater-extracted-this-tick
  total-water-obtained-from-RHS-this-tick
  total-penalties-collected-this-tick
  total-subsidies-distributed-this-tick
  funds-for-monitoring-scheme
  funds-for-subsidies
  subsidy-stock
  subsidy-record
  monitoring-cost-per-person
  rainfall-sum
  average-rainfall
  tax-collected-sum
  monitoring-cost-sum
  penalties-collected-sum
  subsidies-distributed-sum
  GWW-installations-sum
  RHS-installations-sum
  gini-index-each-tick
  lorenz-points
  ; to record outcomes at different points of time
  %-people-achieving-sufficiency-at-1000-ticks
  %-people-not-achieving-sufficiency-at-1000-ticks
  mean-welfare-stock-at-1000-ticks
  %-GWW-count-at-1000-ticks
  %-RHS-count-at-1000-ticks
  %-no-supplementing-system-count-at-1000-ticks
  %-groundwater-volume-left-at-1000-ticks
  average-tax-collected-at-1000-ticks
  average-monitoring-cost-at-1000-ticks
  average-penalties-collected-at-1000-ticks
  average-subsidies-distributed-at-1000-ticks
  social-capital-welfare-correlation-at-1000-ticks
  sufficiency-outcome-running-average-at-1000-ticks
  %-people-achieving-sufficiency-at-5000-ticks
  %-people-not-achieving-sufficiency-at-5000-ticks
  mean-welfare-stock-at-5000-ticks
  %-GWW-count-at-5000-ticks
  %-RHS-count-at-5000-ticks
  %-no-supplementing-system-count-at-5000-ticks
  %-groundwater-volume-left-at-5000-ticks
  average-tax-collected-at-5000-ticks
  average-monitoring-cost-at-5000-ticks
  average-penalties-collected-at-5000-ticks
  average-subsidies-distributed-at-5000-ticks
  social-capital-welfare-correlation-at-5000-ticks
  sufficiency-outcome-running-average-at-5000-ticks
  %-people-achieving-sufficiency-at-10000-ticks
  %-people-not-achieving-sufficiency-at-10000-ticks
  mean-welfare-stock-at-10000-ticks
  %-GWW-count-at-10000-ticks
  %-RHS-count-at-10000-ticks
  %-no-supplementing-system-count-at-10000-ticks
  %-groundwater-volume-left-at-10000-ticks
  average-tax-collected-at-10000-ticks
  average-monitoring-cost-at-10000-ticks
  average-penalties-collected-at-10000-ticks
  average-subsidies-distributed-at-10000-ticks
  social-capital-welfare-correlation-at-10000-ticks
  sufficiency-outcome-running-average-at-10000-ticks
  %-people-achieving-sufficiency-at-15000-ticks
  %-people-not-achieving-sufficiency-at-15000-ticks
  mean-welfare-stock-at-15000-ticks
  %-GWW-count-at-15000-ticks
  %-RHS-count-at-15000-ticks
  %-no-supplementing-system-count-at-15000-ticks
  %-groundwater-volume-left-at-15000-ticks
  average-tax-collected-at-15000-ticks
  average-monitoring-cost-at-15000-ticks
  average-penalties-collected-at-15000-ticks
  average-subsidies-distributed-at-15000-ticks
  social-capital-welfare-correlation-at-15000-ticks
  sufficiency-outcome-running-average-at-15000-ticks
  %-people-achieving-sufficiency-at-20000-ticks
  %-people-not-achieving-sufficiency-at-20000-ticks
  mean-welfare-stock-at-20000-ticks
  %-GWW-count-at-20000-ticks
  %-RHS-count-at-20000-ticks
  %-no-supplementing-system-count-at-20000-ticks
  %-groundwater-volume-left-at-20000-ticks
  average-tax-collected-at-20000-ticks
  average-monitoring-cost-at-20000-ticks
  average-penalties-collected-at-20000-ticks
  average-subsidies-distributed-at-20000-ticks
  social-capital-welfare-correlation-at-20000-ticks
  sufficiency-outcome-running-average-at-20000-ticks
  min-groundwater-volume
  sum-groundwater-volume
  mean-groundwater-volume
  ; stdev-groundwater-volume
  sufficiency-outcome-record
]

breed [ people a-person ]

people-own [
  social-capital
  starting-welfare-stock
  welfare-stock
  desired-welfare-level
  welfare-gained-this-tick
  welfare-lost-this-tick
  welfare-gain-record
  welfare-net-record ; list to record last N (6-12?) months' net welfare
  sufficiency-record
  sufficiency-index
  water-obtained-from-municipal-supply
  water-obtained-from-GWW
  my-RHS-capacity
  my-RHS-cost
  current-RHS-water-stock
  water-obtained-from-RHS
  water-obtained-this-tick
  tax-paid-this-tick
  current-system
  current-system-lifetime
  last-system
  first-system-installation?
  system-to-install
  supplementing-system-cost
  RHS-subsidy-received-this-tick
  num-times-caught-using-GWW
  penalty-paid-this-tick
  GWW-sufficiency-experience
  RHS-sufficiency-experience
]

to setup
  clear-all
  if profile? [
    profiler:reset         ; clear the data
    profiler:start         ; start profiling
  ]
  setup-parameters
  setup-community
  reset-ticks
end

to setup-parameters
  ; for BehaviorSpace experiments
  set population 300
  set drought-index one-of [ 0.82 0.87 0.92 ] ; ( 0.7 + random-float ( 1 - 0.7 ) )
  set rainfall-pattern one-of [ "evenly distributed" "seasonal peak" ]
  ; set run-scenario one-of [ "monitoring on subsidies on" "monitoring on subsidies off" "monitoring off subsidies on" "monitoring off subsidies off" ]
  let scenario-selector random-float 1
;  ifelse scenario-selector >= 0.97 [ set run-scenario one-of [ "monitoring off subsidies off" ] ]
;  [ ifelse scenario-selector < 0.30 [ set run-scenario one-of [ "monitoring off subsidies on" "monitoring on subsidies off" ] ]
;    [ set run-scenario "monitoring on subsidies on" ] ]
  set run-scenario one-of [ "monitoring off subsidies off" "monitoring off subsidies on" "monitoring on subsidies off" ]
  set tax-policy one-of [ "flat rate" "progressive" ]
  set tax-level random-float 1
  set preservation-limit one-of [ 90 60 30 ] ; 50 + random-float ( 100 - 50 )
  set monitoring-rate random-float 100
  set monitoring-cost 0.1 ; random-float 1
  set penalty-severity ( 0.10 + random-float ( 1 - 0.10 ) )
  set consumption-restraint one-of [ 0.33 0.67 1 ]
  set GWW-RHS-cost-ratio one-of [ 0.20 0.40 0.60 ]
  ; other parameters
  set welfare-sufficiency-threshold 10 ; welfare units per tick
  set peak-monthly-rainfall ( 5 * welfare-sufficiency-threshold * population * ( 1 - drought-index ) )
  set groundwater-supply-longevity 10 ; the number of years for which the starting groundwater volume is able to provide the amount of water needed to achieve the
                                    ; welfare-sufficiency-threshold for the population.
  set starting-groundwater-volume ( 12 * groundwater-supply-longevity * welfare-sufficiency-threshold * population )
  set groundwater-volume starting-groundwater-volume
  set total-tax-collected-record [ ]
  set base-RHS-cost ( 2 * welfare-sufficiency-threshold )
  set starting-GWW-cost ( GWW-RHS-cost-ratio * base-RHS-cost ) ;
  set GWW-cost starting-GWW-cost
  set GWW-lifetime ( 5 * 12 ) ; 5 years' operational lifetime
  set RHS-lifetime ( 5 * 12 )
  set base-RHS-capacity ( 2 * welfare-sufficiency-threshold ) ; 2 months' capacity
  set monitoring-cost-per-person ( welfare-sufficiency-threshold * monitoring-cost )
  set subsidy-record [ ]
  set min-groundwater-volume groundwater-volume
  set sufficiency-outcome-record [ ]
end

to setup-community
  set-default-shape people "person"
  let min-social-capital 0.1
  let max-social-capital 1
  ask n-of population patches with [ not any? turtles-here ] [
    sprout-people 1 [
      set social-capital ( min-social-capital + random-float ( max-social-capital - min-social-capital ) )
      set desired-welfare-level ( welfare-sufficiency-threshold + consumption-restraint * 5 * social-capital * welfare-sufficiency-threshold )
      set color 45
      set starting-welfare-stock ( welfare-sufficiency-threshold + random-float ( desired-welfare-level - welfare-sufficiency-threshold ) )
      set welfare-stock starting-welfare-stock
      set welfare-gain-record [ ]
      set welfare-net-record [ ]
      set sufficiency-record [ ]
      set current-system "none"
      set system-to-install "none"
      set first-system-installation? true
      let m ( 2.5 * base-RHS-capacity - base-RHS-capacity ) / ( max-social-capital - min-social-capital )
      let c ( base-RHS-capacity - m * min-social-capital )
      set my-RHS-capacity ( m * social-capital + c )
      set my-RHS-cost ( base-RHS-cost * ( my-RHS-capacity / base-RHS-capacity ) ^ ( 1 / 2 ) )
    ]
  ]
end

to go
  no-display
  if ticks > 20001 [ stop ]
  reset-variables
  let-it-rain
  do-municipal-supply
  if run-scenario != "monitoring off subsidies off" [ collect-and-allocate-taxes ]
  decide-supplmenting-system-to-install
  install-supplementing-system
  ask people with [ current-system = "RHS" ] [ harvest-rainwater ]
  use-supplementing-system
  if run-scenario = "monitoring on subsidies off" or run-scenario = "monitoring on subsidies on" [ monitor-and-penalize-GWW-use ]
  if run-scenario = "monitoring on subsidies on" or run-scenario = "monitoring off subsidies on" [ allocate-subsidies-for-RHS ]
  calculate-peoples-welfare
  update-groundwater-well-state
  ; update-lorenz-and-gini
  measure-some-milestones
  tick
end

to calculate-peoples-welfare
  ask people [
    set label round welfare-stock
    set welfare-net-record map [ i -> i * ( 11 / 12 ) ] welfare-net-record
    set water-obtained-this-tick ( water-obtained-from-municipal-supply + water-obtained-from-GWW + water-obtained-from-RHS )
    set welfare-gained-this-tick ( 1 * water-obtained-this-tick )
    set welfare-lost-this-tick ( tax-paid-this-tick + penalty-paid-this-tick + supplementing-system-cost )
    set welfare-net-record lput ( welfare-gained-this-tick - welfare-lost-this-tick ) welfare-net-record
    if length welfare-net-record > 12 [ set welfare-net-record but-first welfare-net-record ]
    set welfare-stock sum welfare-net-record
;    ifelse welfare-stock >= welfare-sufficiency-threshold [ set sufficiency-record lput 1 sufficiency-record ]
;    [ set sufficiency-record lput 0 sufficiency-record ]
    ifelse welfare-stock >= welfare-sufficiency-threshold [ set sufficiency-record lput 1 sufficiency-record ]
    [ set sufficiency-record lput ( welfare-stock / welfare-sufficiency-threshold ) sufficiency-record ]
    if length sufficiency-record > 12 [ set sufficiency-record but-first sufficiency-record ]
    set sufficiency-index mean sufficiency-record
  ]
end

to reset-variables
  ask people [
    set water-obtained-from-municipal-supply 0
    set water-obtained-from-GWW 0
    set water-obtained-from-RHS 0
    set welfare-gained-this-tick 0
    set welfare-lost-this-tick 0
    set tax-paid-this-tick 0
    set penalty-paid-this-tick 0
    set supplementing-system-cost 0
    if current-system != "none" and ( ticks - supplementing-system-last-installed-at ) = current-system-lifetime [
      set current-system "none"
      set system-to-install "none"
      set color 45
    ]
  ]
  set total-tax-collected-this-tick 0
  set funds-for-monitoring-scheme 0
  set funds-for-subsidies 0
  set total-penalties-collected-this-tick 0
  set total-subsidies-distributed-this-tick 0
  set sufficiency-outcome-record lput %-people-achieving-sufficiency sufficiency-outcome-record
  if length sufficiency-outcome-record > 12 [ set sufficiency-outcome-record but-first sufficiency-outcome-record ]
end

to let-it-rain
  if ticks > 1 and ticks mod 12 = 0 [
    set year-count ( year-count + 1 )
  ]
  if rainfall-pattern = "evenly distributed" [
    set monthly-rainfall round random-normal peak-monthly-rainfall ( 0.2 * peak-monthly-rainfall ) ; standard-deviation of 20% of the peak-monthly-rainfall value
    if monthly-rainfall < 0 [ set monthly-rainfall 0 ]
  ]
  if rainfall-pattern = "seasonal peak" [
    let month-of-year ticks mod 12
    let time-distance-from-mid-year abs ( 6 - month-of-year )
    set monthly-rainfall round random-normal ( peak-monthly-rainfall * ( 1 - time-distance-from-mid-year / 6 ) ) ( 0.2 * peak-monthly-rainfall )
    if monthly-rainfall < 0 [ set monthly-rainfall 0 ]
  ]
   set rainfall-sum ( rainfall-sum + monthly-rainfall )
   if ticks > 0 [ set average-rainfall ( rainfall-sum / ticks ) ]
end

to do-municipal-supply
  set municipal-water-supply-available ( ( 1 / 3 ) * monthly-rainfall )
  let social-capital-sum sum [ social-capital ] of people
  ask people [
    set water-obtained-from-municipal-supply ( ( social-capital / social-capital-sum ) * municipal-water-supply-available )
  ]
end

to collect-and-allocate-taxes
  ask people with [ welfare-stock > welfare-sufficiency-threshold ] [
    let taxable-welfare ( welfare-stock - welfare-sufficiency-threshold )
    let tax-to-pay 0
    if tax-policy = "flat rate" [
      set tax-to-pay ( 0.5 * tax-level * taxable-welfare )
    ]
    if tax-policy = "progressive" [
      set tax-to-pay ( social-capital * tax-level * taxable-welfare )
    ]
    set tax-paid-this-tick tax-to-pay
    set welfare-stock ( welfare-stock - tax-paid-this-tick )
    set total-tax-collected-this-tick ( total-tax-collected-this-tick + tax-to-pay )
    set total-tax-collected-record lput total-tax-collected-this-tick total-tax-collected-record
    set tax-collected-sum ( tax-collected-sum + total-tax-collected-this-tick )
    if length total-tax-collected-record > 12 [ set total-tax-collected-record but-first total-tax-collected-record ]
  ]
end

to decide-supplmenting-system-to-install
  ask people with [ ( welfare-stock / 12 ) < desired-welfare-level and current-system = "none" ] [
    ifelse first-system-installation? = true [
      ifelse random-float 1 > 0.5 [ set system-to-install "GWW" ] [ set system-to-install "RHS" ]
    ]
    [
      ifelse count people with [ current-system != "none" ] > 0 [
        ask one-of people with [ current-system != "none" ] [
          ifelse welfare-stock > [ welfare-stock ] of myself [
            if current-system = "GWW" [ ask myself [ set system-to-install "GWW" ] ]
            if current-system = "RHS" [ ask myself [ set system-to-install "RHS" ] ]
          ]
          [
            set system-to-install last-system
          ]
        ]
      ]
      [
        ifelse random-float 1 > 0.5 [ set system-to-install "GWW" ] [ set system-to-install "RHS" ]
      ]
    ]
  ]
end

;to decide-supplmenting-system-to-install
;  ask people with [ welfare-stock < desired-welfare-level and current-system = "none" ] [
;    ifelse first-system-installation? = true [
;      ifelse random-float 1 > 0.5 [ set system-to-install "GWW" ] [ set system-to-install "RHS" ]
;    ]
;    [
;      ifelse sufficiency-index < random-float 1 [ ; ] [  ]
;      ; ifelse sufficiency-index < 0.75 [
;        let cheaper-system one-of [ "RHS" "GWW" ]
;        if GWW-cost > my-RHS-cost [ set cheaper-system "RHS" ]
;        if GWW-cost < my-RHS-cost [ set cheaper-system "GWW" ]
;        ifelse last-system = "RHS" and GWW-cost < welfare-stock [ set system-to-install "GWW" ] [ set system-to-install cheaper-system ]
;        ifelse last-system = "GWW" and my-RHS-cost < welfare-stock [ set system-to-install "RHS" ] [ set system-to-install cheaper-system ]
;      ]
;      [
;        ifelse count people with [ current-system != "none" ] > 0 [
;          ask one-of people with [ current-system != "none" ] [
;            ifelse welfare-stock > [ welfare-stock ] of myself [
;              if current-system = "GWW" [ ask myself [ set system-to-install "GWW" ] ]
;              if current-system = "RHS" [ ask myself [ set system-to-install "RHS" ] ]
;            ]
;            [
;              set system-to-install last-system
;            ]
;          ]
;        ]
;        [
;          set system-to-install last-system
;        ]
;      ]
;    ]
;  ]
;end

to install-supplementing-system
  ask people with [ system-to-install != "none" ] [
    if system-to-install = "GWW" and welfare-stock >= GWW-cost [ install-GWW ]
    ifelse system-to-install = "RHS" and welfare-stock >= my-RHS-cost [
      install-RHS
      set supplementing-system-cost my-RHS-cost
    ]
    [
      if subsidy-stock >= my-RHS-cost [
        install-RHS
        set subsidy-stock ( subsidy-stock - my-RHS-cost )
        set total-subsidies-distributed-this-tick ( total-subsidies-distributed-this-tick + my-RHS-cost )
        set subsidies-distributed-sum ( subsidies-distributed-sum + total-subsidies-distributed-this-tick )
      ]
    ]
  ]
end

to install-GWW
  set supplementing-system-cost GWW-cost
  set welfare-stock ( welfare-stock - supplementing-system-cost ) ;;
  set current-system "GWW"
  set last-system "GWW"
  set supplementing-system-last-installed-at ticks
  set current-system-lifetime GWW-lifetime
  set system-to-install "none"
  set first-system-installation? false
  set color 35
  set GWW-installations-sum ( GWW-installations-sum + 1 )
end

to install-RHS
  set welfare-stock ( welfare-stock - supplementing-system-cost ) ;;
  set current-system "RHS"
  set last-system "RHS"
  set supplementing-system-last-installed-at ticks
  set current-system-lifetime RHS-lifetime
  set system-to-install "none"
  set first-system-installation? false
  set color 75
  set RHS-installations-sum ( RHS-installations-sum + 1 )
end

to harvest-rainwater
  let rainfall-harvestable ( ( 1 / 3 ) * monthly-rainfall )
  let max-rainfall-share-per-person ( 0.3 * rainfall-harvestable / population ) ; the constant 0.3 is like an efficiency factor or % of the RHS
  if current-RHS-water-stock < my-RHS-capacity [
    set current-RHS-water-stock ( current-RHS-water-stock + max-rainfall-share-per-person )
    if current-RHS-water-stock > my-RHS-capacity [ set current-RHS-water-stock my-RHS-capacity ]
  ]
end

to use-supplementing-system
  ask people with [ welfare-stock < desired-welfare-level and current-system != "none" ] [
    let welfare-desired-deficit ( desired-welfare-level - welfare-stock )
    if current-system = "GWW" [
      ifelse groundwater-volume >= welfare-desired-deficit [
        set water-obtained-from-GWW welfare-desired-deficit
        set groundwater-volume ( groundwater-volume - water-obtained-from-GWW )
      ]
      [
        set water-obtained-from-GWW groundwater-volume
        set groundwater-volume 0
      ]
    ]
    if current-system = "RHS" [
      ifelse current-RHS-water-stock >= ( welfare-desired-deficit / 1 ) [
        set water-obtained-from-RHS ( welfare-desired-deficit / 1 )
        set current-RHS-water-stock ( current-RHS-water-stock - water-obtained-from-RHS )
      ]
      [
        set water-obtained-from-RHS current-RHS-water-stock
        set current-RHS-water-stock 0
      ]
    ]
  ]
end

to monitor-and-penalize-GWW-use
  if groundwater-volume < ( preservation-limit * starting-groundwater-volume ) [
    let number-of-people-to-inspect round ( monitoring-rate / 100 ) * population
    let total-funds-needed-to-inspect ( monitoring-cost-per-person * number-of-people-to-inspect )
    set funds-for-monitoring-scheme total-funds-needed-to-inspect
    if total-funds-needed-to-inspect > total-tax-collected-this-tick [
      set funds-for-monitoring-scheme total-tax-collected-this-tick
      set number-of-people-to-inspect round ( funds-for-monitoring-scheme / monitoring-cost-per-person )
    ]
    set monitoring-cost-sum ( monitoring-cost-sum + funds-for-monitoring-scheme )
    ask n-of number-of-people-to-inspect people [
      if water-obtained-from-GWW > 0 [
        ifelse welfare-stock >= ( penalty-severity * welfare-stock ) [
          set penalty-paid-this-tick ( penalty-severity * welfare-stock )
          set welfare-stock ( welfare-stock - penalty-paid-this-tick ) ;;
        ]
        [
          set penalty-paid-this-tick welfare-stock
          set welfare-stock 0
        ]
        ; print penalty-paid-this-tick
        set total-penalties-collected-this-tick ( total-penalties-collected-this-tick + penalty-paid-this-tick )
        set penalties-collected-sum ( penalties-collected-sum + total-penalties-collected-this-tick )
        set num-times-caught-using-GWW ( num-times-caught-using-GWW + 1 )
      ]
    ]
  ]
end

to allocate-subsidies-for-RHS
  set subsidy-record map [ i -> i * ( 11 / 12 ) ] subsidy-record
  set funds-for-subsidies ( total-tax-collected-this-tick - funds-for-monitoring-scheme + total-penalties-collected-this-tick )
  set subsidy-record lput ( funds-for-subsidies - total-subsidies-distributed-this-tick ) subsidy-record
  if length subsidy-record > 12 [ set subsidy-record but-first subsidy-record ]
  set subsidy-stock sum subsidy-record
  ; calculate subsidy-stock
;  let weighted-subsidy-sum 0
;  foreach subsidy-record [ x ->
;    let weighted-subsidy-value ( x * ( 1 + position x subsidy-record ) / length subsidy-record )
;    set weighted-subsidy-sum ( weighted-subsidy-sum + weighted-subsidy-value )
;  ]
;  set subsidy-stock weighted-subsidy-sum
end

to update-groundwater-well-state
  let rainfall-available-for-percolation ( ( 1 / 3 ) * monthly-rainfall )
  let percolation-index ( groundwater-volume / starting-groundwater-volume )
  if percolation-index < 0.2 [ set percolation-index 0.2 ]
  set rainfall-percolated-to-groundwater ( 0.1 * rainfall-available-for-percolation * percolation-index ^ ( 1 / 2 ) )
  set groundwater-volume ( groundwater-volume + rainfall-percolated-to-groundwater )
  if groundwater-volume > starting-groundwater-volume [ set groundwater-volume starting-groundwater-volume ]
  if groundwater-volume > 0 [
    set GWW-cost ( starting-GWW-cost * ( starting-groundwater-volume / groundwater-volume ) ^ ( 1 / 4 ) )
  ]
  if min-groundwater-volume > groundwater-volume [ set min-groundwater-volume groundwater-volume ]
  set sum-groundwater-volume ( sum-groundwater-volume + groundwater-volume )
  ifelse ticks > 0 [ set mean-groundwater-volume ( sum-groundwater-volume / ticks ) ] [ set mean-groundwater-volume groundwater-volume ]
end

to update-lorenz-and-gini
  let sorted-welfare-stocks sort [ welfare-stock ] of people
  let total-welfare-stock sum sorted-welfare-stocks
  let welfare-stock-sum-so-far 0
  let index 0
  let gini-index-reserve 0
  set lorenz-points n-values count people [ 0 ]
  repeat count people [
    set welfare-stock-sum-so-far ( welfare-stock-sum-so-far + item index sorted-welfare-stocks )
    if total-welfare-stock > 0 [
      set lorenz-points replace-item index lorenz-points ( ( welfare-stock-sum-so-far / total-welfare-stock ) * 100 )
      set index ( index + 1 )
      set gini-index-reserve ( gini-index-reserve + ( index / count people ) - ( welfare-stock-sum-so-far / total-welfare-stock ) )
      set gini-index-each-tick ( 2 * gini-index-reserve / count people )
    ]
  ]
end

to measure-some-milestones
  if ticks = 1000 [
    set %-people-achieving-sufficiency-at-1000-ticks %-people-achieving-sufficiency
    set %-people-not-achieving-sufficiency-at-1000-ticks %-people-not-achieving-sufficiency
    set mean-welfare-stock-at-1000-ticks mean-welfare-stock
    set %-GWW-count-at-1000-ticks %-GWW-count
    set %-RHS-count-at-1000-ticks %-RHS-count
    set %-no-supplementing-system-count-at-1000-ticks %-no-supplementing-system-count
    set %-groundwater-volume-left-at-1000-ticks %-groundwater-volume-left
    set average-tax-collected-at-1000-ticks average-tax-collected
    set average-monitoring-cost-at-1000-ticks average-monitoring-cost
    set average-penalties-collected-at-1000-ticks average-penalties-collected
    set average-subsidies-distributed-at-1000-ticks average-subsidies-distributed
    set sufficiency-outcome-running-average-at-1000-ticks sufficiency-outcome-running-average
  ]
  if ticks = 5000 [
    set %-people-achieving-sufficiency-at-5000-ticks %-people-achieving-sufficiency
    set %-people-not-achieving-sufficiency-at-5000-ticks %-people-not-achieving-sufficiency
    set mean-welfare-stock-at-5000-ticks mean-welfare-stock
    set %-GWW-count-at-5000-ticks %-GWW-count
    set %-RHS-count-at-5000-ticks %-RHS-count
    set %-no-supplementing-system-count-at-5000-ticks %-no-supplementing-system-count
    set %-groundwater-volume-left-at-5000-ticks %-groundwater-volume-left
    set average-tax-collected-at-5000-ticks average-tax-collected
    set average-monitoring-cost-at-5000-ticks average-monitoring-cost
    set average-penalties-collected-at-5000-ticks average-penalties-collected
    set average-subsidies-distributed-at-5000-ticks average-subsidies-distributed
    set sufficiency-outcome-running-average-at-5000-ticks sufficiency-outcome-running-average
  ]
  if ticks = 10000 [
    set %-people-achieving-sufficiency-at-10000-ticks %-people-achieving-sufficiency
    set %-people-not-achieving-sufficiency-at-10000-ticks %-people-not-achieving-sufficiency
    set mean-welfare-stock-at-10000-ticks mean-welfare-stock
    set %-GWW-count-at-10000-ticks %-GWW-count
    set %-RHS-count-at-10000-ticks %-RHS-count
    set %-no-supplementing-system-count-at-10000-ticks %-no-supplementing-system-count
    set %-groundwater-volume-left-at-10000-ticks %-groundwater-volume-left
    set average-tax-collected-at-10000-ticks average-tax-collected
    set average-monitoring-cost-at-10000-ticks average-monitoring-cost
    set average-penalties-collected-at-10000-ticks average-penalties-collected
    set average-subsidies-distributed-at-10000-ticks average-subsidies-distributed
    set sufficiency-outcome-running-average-at-10000-ticks sufficiency-outcome-running-average
  ]
  if ticks = 15000 [
    set %-people-achieving-sufficiency-at-15000-ticks %-people-achieving-sufficiency
    set %-people-not-achieving-sufficiency-at-15000-ticks %-people-not-achieving-sufficiency
    set mean-welfare-stock-at-15000-ticks mean-welfare-stock
    set %-GWW-count-at-15000-ticks %-GWW-count
    set %-RHS-count-at-15000-ticks %-RHS-count
    set %-no-supplementing-system-count-at-15000-ticks %-no-supplementing-system-count
    set %-groundwater-volume-left-at-15000-ticks %-groundwater-volume-left
    set average-tax-collected-at-15000-ticks average-tax-collected
    set average-monitoring-cost-at-15000-ticks average-monitoring-cost
    set average-penalties-collected-at-15000-ticks average-penalties-collected
    set average-subsidies-distributed-at-15000-ticks average-subsidies-distributed
    set sufficiency-outcome-running-average-at-15000-ticks sufficiency-outcome-running-average
  ]
  if ticks = 20000 [
    set %-people-achieving-sufficiency-at-20000-ticks %-people-achieving-sufficiency
    set %-people-not-achieving-sufficiency-at-20000-ticks %-people-not-achieving-sufficiency
    set mean-welfare-stock-at-20000-ticks mean-welfare-stock
    set %-GWW-count-at-20000-ticks %-GWW-count
    set %-RHS-count-at-20000-ticks %-RHS-count
    set %-no-supplementing-system-count-at-20000-ticks %-no-supplementing-system-count
    set %-groundwater-volume-left-at-20000-ticks %-groundwater-volume-left
    set average-tax-collected-at-20000-ticks average-tax-collected
    set average-monitoring-cost-at-20000-ticks average-monitoring-cost
    set average-penalties-collected-at-20000-ticks average-penalties-collected
    set average-subsidies-distributed-at-20000-ticks average-subsidies-distributed
    set sufficiency-outcome-running-average-at-20000-ticks sufficiency-outcome-running-average
  ]
end

to-report %-people-achieving-sufficiency
  report 100 * count people with [ welfare-stock >= welfare-sufficiency-threshold ] / population
end

to-report %-people-not-achieving-sufficiency
  report 100 * count people with [ welfare-stock < welfare-sufficiency-threshold ] / population
end

to-report sufficiency-outcome-running-average
  report mean sufficiency-outcome-record
end

to-report mean-welfare-stock
  report mean [ welfare-stock ] of people
end

to-report median-welfare-stock
  report median [ welfare-stock ] of people
end

to-report %-GWW-count
  report 100 * count people with [ current-system = "GWW" ] / population
end

to-report %-RHS-count
  report 100 * count people with [ current-system = "RHS" ] / population
end

to-report %-no-supplementing-system-count
  report ( 100 - ( %-GWW-count + %-RHS-count ) )
end

to-report %-groundwater-volume-left
  report 100 * groundwater-volume / starting-groundwater-volume
end

to-report average-tax-collected
  ifelse ticks > 0 [ report ( tax-collected-sum / ticks ) ] [ report 0 ]
end

to-report average-monitoring-cost
  ifelse ticks > 0 [ report ( monitoring-cost-sum / ticks ) ] [ report 0 ]
end

to-report average-penalties-collected
  ifelse ticks > 0 [ report ( penalties-collected-sum / ticks ) ] [ report 0 ]
end

to-report average-subsidies-distributed
  ifelse ticks > 0 [ report ( subsidies-distributed-sum / ticks ) ] [ report 0 ]
end

to-report sum-water-from-municipal-supply
  report sum [ water-obtained-from-municipal-supply ] of people
end

to-report sum-water-from-GWW
  report sum [ water-obtained-from-GWW ] of people
end

to-report sum-water-from-RHS
  report sum [ water-obtained-from-RHS ] of people
end

to-report correlation-social-capital-welfare-stock
  let data [ ( list social-capital welfare-stock ) ] of people
  let tbl stats:newtable-from-row-list data
  ; Calculate a correlation matrix with `stats:correlation`:
  let cor-list stats:correlation tbl
  report item 0 item 1 cor-list
end























@#$#@#$#@
GRAPHICS-WINDOW
286
10
589
314
-1
-1
8.94
1
10
1
1
1
0
1
1
1
-16
16
-16
16
0
0
1
ticks
30.0

CHOOSER
8
136
138
181
rainfall-pattern
rainfall-pattern
"evenly distributed" "seasonal peak"
1

SLIDER
9
52
139
85
population
population
0
500
300.0
1
1
NIL
HORIZONTAL

SLIDER
9
94
139
127
drought-index
drought-index
0
1
0.92
0.01
1
NIL
HORIZONTAL

BUTTON
9
10
81
43
setup
setup 
NIL
1
T
OBSERVER
NIL
Q
NIL
NIL
1

BUTTON
89
10
161
43
go
go
T
1
T
OBSERVER
NIL
A
NIL
NIL
1

BUTTON
169
10
241
43
tick
go
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

CHOOSER
8
190
138
235
tax-policy
tax-policy
"flat rate" "progressive"
0

PLOT
599
10
806
130
water supplementing systems count
ticks
% people
0.0
10.0
0.0
100.0
true
true
"" ""
PENS
"no-system" 1.0 0 -1184463 true "" "if graphs-on? [ plot %-no-supplementing-system-count ]"
"RHS" 1.0 0 -14835848 true "" "if graphs-on? [ plot %-RHS-count ]"
"GWW" 1.0 0 -6459832 true "" "if graphs-on? [ plot %-GWW-count ]"

PLOT
599
140
806
260
groundwater volume
ticks
% initial
0.0
10.0
0.0
100.0
true
false
"" ""
PENS
"default" 1.0 2 -6459832 true "" "if graphs-on? [ plot %-groundwater-volume-left ]"

SLIDER
147
52
277
85
monitoring-rate
monitoring-rate
0
100
59.0
1
1
%
HORIZONTAL

PLOT
815
10
1022
130
sufficiency outcome
ticks
% people
0.0
10.0
0.0
100.0
true
true
"" ""
PENS
"sufficient" 1.0 0 -14439633 true "" "if graphs-on? [ plot %-people-achieving-sufficiency ]"
"not-suffi." 1.0 0 -5298144 true "" "if graphs-on? [ plot %-people-not-achieving-sufficiency ]"

SLIDER
146
94
276
127
monitoring-cost
monitoring-cost
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
146
136
276
169
penalty-severity
penalty-severity
0
1
0.68
0.01
1
NIL
HORIZONTAL

SLIDER
8
244
138
277
tax-level
tax-level
0
1
0.3
0.01
1
NIL
HORIZONTAL

PLOT
599
271
806
391
monthly rainfall
ticks
water units
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 2 -13791810 true "" "if graphs-on? [ plot monthly-rainfall ]"

PLOT
816
140
1023
260
welfare outcome
ticks
welfare units
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"mean" 1.0 0 -11053225 true "" "if graphs-on? [ plot mean-welfare-stock ]"
"median" 1.0 0 -13791810 true "" "if graphs-on? [ plot median-welfare-stock ]"

PLOT
816
271
1023
391
sufficiency by social-capital
social-capital
# people
0.0
1.0
0.0
10.0
true
false
"" ""
PENS
"default" 0.1 1 -16777216 true "" "if graphs-on? [ \nhistogram [social-capital] of people with [welfare-stock >= welfare-sufficiency-threshold]\n]"

SWITCH
454
324
544
357
profile?
profile?
1
1
-1000

PLOT
1031
10
1238
130
systems by social capital
social-capital
# people
0.0
1.0
0.0
10.0
true
true
"" ""
PENS
"no-system" 0.1 1 -1184463 true "" "if graphs-on? [ \nhistogram [social-capital] of people with [current-system = \"none\"]\n]"
"RHS" 0.1 1 -14835848 true "" "if graphs-on? [ \nhistogram [social-capital] of people with [current-system = \"RHS\"]\n]"
"GWW" 0.1 1 -6459832 true "" "if graphs-on? [ \nhistogram [social-capital] of people with [current-system = \"GWW\"]\n]"

SLIDER
146
179
276
212
consumption-restraint
consumption-restraint
0
1
0.33
0.01
1
NIL
HORIZONTAL

PLOT
1032
140
1239
260
tax allocation
ticks
tax funds
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"tax-coll." 1.0 0 -16777216 true "" "if graphs-on? [ plot total-tax-collected-this-tick ]"
"monit." 1.0 0 -7500403 true "" "if graphs-on? [ plot funds-for-monitoring-scheme ]"
"subs." 1.0 0 -2674135 true "" "if graphs-on? [ plot funds-for-subsidies ]"
"penal." 1.0 0 -955883 true "" "if graphs-on? [ plot total-penalties-collected-this-tick ]"

SLIDER
147
221
277
254
preservation-limit
preservation-limit
0
100
90.0
1
1
%
HORIZONTAL

PLOT
1032
271
1239
391
water supply
ticks
water units
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"municipal" 1.0 0 -1184463 true "" "if graphs-on? [ plot sum-water-from-municipal-supply ]"
"GWW" 1.0 0 -6459832 true "" "if graphs-on? [ plot sum-water-from-GWW ]"
"RHS" 1.0 0 -14835848 true "" "if graphs-on? [ plot sum-water-from-RHS ]"

SLIDER
8
287
138
320
GWW-RHS-cost-ratio
GWW-RHS-cost-ratio
0.1
2
0.4
0.01
1
NIL
HORIZONTAL

PLOT
1248
10
1455
130
Lorenz curve
% people
% welfare
0.0
100.0
0.0
100.0
true
true
"" ""
PENS
"equal" 100.0 0 -16777216 true "if graphs-on? [  \nset-current-plot-pen \"equal\"\nplot 0\nplot 100\n]" ""
"Lorenz" 1.0 0 -955883 true "" "if graphs-on? [ \nplot-pen-reset\nset-plot-pen-interval 100 / count people\nplot 0\nforeach lorenz-points plot\n]"

PLOT
1248
140
1455
260
Gini index
ticks
Gini
0.0
10.0
0.0
1.0
true
true
"" ""
PENS
"Gini" 1.0 0 -16777216 true "" "if graphs-on? [ plot gini-index-each-tick ]"

CHOOSER
286
324
445
369
run-scenario
run-scenario
"monitoring off subsidies off" "monitoring off subsidies on" "monitoring on subsidies off" "monitoring on subsidies on"
3

SWITCH
454
367
544
400
graphs-on?
graphs-on?
1
1
-1000

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment-18Oct2023" repetitions="250000" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="20000"/>
    <metric>population</metric>
    <metric>drought-index</metric>
    <metric>rainfall-pattern</metric>
    <metric>average-rainfall</metric>
    <metric>run-scenario</metric>
    <metric>tax-policy</metric>
    <metric>tax-level</metric>
    <metric>monitoring-rate</metric>
    <metric>monitoring-cost</metric>
    <metric>penalty-severity</metric>
    <metric>preservation-limit</metric>
    <metric>consumption-restraint</metric>
    <metric>GWW-RHS-cost-ratio</metric>
    <metric>welfare-sufficiency-threshold</metric>
    <metric>peak-monthly-rainfall</metric>
    <metric>groundwater-supply-longevity</metric>
    <metric>starting-groundwater-volume</metric>
    <metric>starting-GWW-cost</metric>
    <metric>base-RHS-cost</metric>
    <metric>GWW-lifetime</metric>
    <metric>RHS-lifetime</metric>
    <metric>base-RHS-capacity</metric>
    <metric>monitoring-cost-per-person</metric>
    <metric>GWW-installations-sum</metric>
    <metric>RHS-installations-sum</metric>
    <metric>min-groundwater-volume</metric>
    <metric>mean-groundwater-volume</metric>
    <metric>%-people-achieving-sufficiency-at-1000-ticks</metric>
    <metric>%-people-not-achieving-sufficiency-at-1000-ticks</metric>
    <metric>mean-welfare-stock-at-1000-ticks</metric>
    <metric>%-GWW-count-at-1000-ticks</metric>
    <metric>%-RHS-count-at-1000-ticks</metric>
    <metric>%-no-supplementing-system-count-at-1000-ticks</metric>
    <metric>%-groundwater-volume-left-at-1000-ticks</metric>
    <metric>average-tax-collected-at-1000-ticks</metric>
    <metric>average-monitoring-cost-at-1000-ticks</metric>
    <metric>average-penalties-collected-at-1000-ticks</metric>
    <metric>average-subsidies-distributed-at-1000-ticks</metric>
    <metric>social-capital-welfare-correlation-at-1000-ticks</metric>
    <metric>sufficiency-outcome-running-average-at-1000-ticks</metric>
    <metric>%-people-achieving-sufficiency-at-5000-ticks</metric>
    <metric>%-people-not-achieving-sufficiency-at-5000-ticks</metric>
    <metric>mean-welfare-stock-at-5000-ticks</metric>
    <metric>%-GWW-count-at-5000-ticks</metric>
    <metric>%-RHS-count-at-5000-ticks</metric>
    <metric>%-no-supplementing-system-count-at-5000-ticks</metric>
    <metric>%-groundwater-volume-left-at-5000-ticks</metric>
    <metric>average-tax-collected-at-5000-ticks</metric>
    <metric>average-monitoring-cost-at-5000-ticks</metric>
    <metric>average-penalties-collected-at-5000-ticks</metric>
    <metric>average-subsidies-distributed-at-5000-ticks</metric>
    <metric>social-capital-welfare-correlation-at-5000-ticks</metric>
    <metric>sufficiency-outcome-running-average-at-5000-ticks</metric>
    <metric>%-people-achieving-sufficiency-at-10000-ticks</metric>
    <metric>%-people-not-achieving-sufficiency-at-10000-ticks</metric>
    <metric>mean-welfare-stock-at-10000-ticks</metric>
    <metric>%-GWW-count-at-10000-ticks</metric>
    <metric>%-RHS-count-at-10000-ticks</metric>
    <metric>%-no-supplementing-system-count-at-10000-ticks</metric>
    <metric>%-groundwater-volume-left-at-10000-ticks</metric>
    <metric>average-tax-collected-at-10000-ticks</metric>
    <metric>average-monitoring-cost-at-10000-ticks</metric>
    <metric>average-penalties-collected-at-10000-ticks</metric>
    <metric>average-subsidies-distributed-at-10000-ticks</metric>
    <metric>social-capital-welfare-correlation-at-10000-ticks</metric>
    <metric>sufficiency-outcome-running-average-at-10000-ticks</metric>
    <metric>%-people-achieving-sufficiency-at-15000-ticks</metric>
    <metric>%-people-not-achieving-sufficiency-at-15000-ticks</metric>
    <metric>mean-welfare-stock-at-15000-ticks</metric>
    <metric>%-GWW-count-at-15000-ticks</metric>
    <metric>%-RHS-count-at-15000-ticks</metric>
    <metric>%-no-supplementing-system-count-at-15000-ticks</metric>
    <metric>%-groundwater-volume-left-at-15000-ticks</metric>
    <metric>average-tax-collected-at-15000-ticks</metric>
    <metric>average-monitoring-cost-at-15000-ticks</metric>
    <metric>average-penalties-collected-at-15000-ticks</metric>
    <metric>average-subsidies-distributed-at-15000-ticks</metric>
    <metric>social-capital-welfare-correlation-at-15000-ticks</metric>
    <metric>sufficiency-outcome-running-average-at-15000-ticks</metric>
    <metric>%-people-achieving-sufficiency-at-20000-ticks</metric>
    <metric>%-people-not-achieving-sufficiency-at-20000-ticks</metric>
    <metric>mean-welfare-stock-at-20000-ticks</metric>
    <metric>%-GWW-count-at-20000-ticks</metric>
    <metric>%-RHS-count-at-20000-ticks</metric>
    <metric>%-no-supplementing-system-count-at-20000-ticks</metric>
    <metric>%-groundwater-volume-left-at-20000-ticks</metric>
    <metric>average-tax-collected-at-20000-ticks</metric>
    <metric>average-monitoring-cost-at-20000-ticks</metric>
    <metric>average-penalties-collected-at-20000-ticks</metric>
    <metric>average-subsidies-distributed-at-20000-ticks</metric>
    <metric>social-capital-welfare-correlation-at-20000-ticks</metric>
    <metric>sufficiency-outcome-running-average-at-20000-ticks</metric>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
