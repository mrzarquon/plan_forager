# plan_forager


edit exec/submit_to_splunk.rb to include splunk hec hostname and hec token

ruby exec/submit_to_splunk.rb reports/$directory

will send each directories reports stored in json format to the splunk hec end point