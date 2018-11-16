# run a test task
require 'spec_helper_acceptance'

describe 'mysql tasks' do
  describe 'execute some sql' do
    pp = <<-MANIFEST
        class { 'mysql::server': root_password => 'password' }
        mysql::db { 'spec1':
          user     => 'root1',
          password => 'password',
        }
    MANIFEST

    it 'sets up a mysql instance' do
      results = apply_manifest(pp, catch_failures: true)
    end

    it 'execute arbitary sql' do
      result = task_run('mysql::sql', {'sql'=> "show databases;", 'password'=> 'password'})
      expect_multiple_regexes(result: result, regexes: [%r{information_schema}, %r{#{task_summary_line}}])
    end
  end
end