plan discovery::scan (
  TargetSpec $nodes, 
  Boolean $noop,
  String[1] $include_class,
  String[1] $guid,
  ) {
  
  notice("Plain GUID: ${guid} is starting")

  apply_prep($nodes)

  #$servers = run_plan(facts, nodes => $nodes)

  $servers = get_targets($nodes)

  $results = apply ($servers, _catch_errors => true, _noop => $noop, _run_as => root) {
    include $include_class
  }

  $results.each |$result| {
    $node = $result.target.facts['clientcert']
    if $result.ok {
      notice("sending ${node}'s report to splunk")
      splunk_hec::save_report($result.report, $result.target.facts, $guid)
    } else {
      notice("${node} errored with a message: ${result.error}")
    }
  }

  notice("Plain GUID: ${guid} has finished")

}
