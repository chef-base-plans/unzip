title 'Tests to confirm unzip works as expected'

plan_name = input('plan_name', value: 'unzip')
plan_ident = "#{ENV['HAB_ORIGIN']}/#{plan_name}"
hab_path = input('hab_path', value: 'hab')

control 'core-plans-unzip' do
  impact 1.0
  title 'Ensure unzip works'
  desc '
  To test unzip we ensure that the extended help message is shown as expected:

    $ unzip -hh
    Extended Help for UnZip

    See the UnZip Manual for more detailed help
    ...
  '
  unzip_pkg_ident = command("#{hab_path} pkg path #{plan_ident}")
  describe unzip_pkg_ident do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
  end
  unzip_pkg_ident = unzip_pkg_ident.stdout.strip

  describe command("#{unzip_pkg_ident}/bin/unzip -hh") do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
    its('stdout') { should match /Extended Help for UnZip/ }
    its('stderr') { should be_empty }
  end
end
