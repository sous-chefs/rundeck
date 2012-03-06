# The MIT License
# Copyright (c) 2011 Automated Labs, LLC
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.


define :hosts_entry, :ip => "", :aliases => [], :comment => "" do
 
    tl = cookbook_file "/etc/hosts.local" do
        owner "root"
        group "root"
        mode  0644
        cookbook "hosts"
        source "hosts.local"
        action :nothing
    end
    tl.run_action(:create_if_missing)

    t = nil
    begin
        t = resources(:template => "/etc/hosts")
    rescue Chef::Exceptions::ResourceNotFound
        t = template "/etc/hosts" do
            mode 0644
            owner "root"
            group "root"
            source "hosts.erb"
            cookbook "hosts"
            variables(:entries => [], :localdata => IO.read("/etc/hosts.local") )
        end
    end

    t.variables[:entries] << {
        :fqdn => params[:name],
        :ip => params[:ip], 
        :aliases => params[:aliases],
        :comment => params[:comment]}
end

