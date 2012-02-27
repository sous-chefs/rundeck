installdir = node['wt_common']['installdir']

directory "#{installdir}" do
  recursive true
  action :delete
end