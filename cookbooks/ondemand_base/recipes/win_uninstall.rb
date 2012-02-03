installdir = node['webtrends']['installdir']

directory "#{installdir}" do
  recursive true
  action :delete
end