module Test
  module Rsync
    include MiniTest::Chef::Assertions
    include MiniTest::Chef::Context
    include MiniTest::Chef::Resources

    # doesn't pickup cmdline --ports 
    def rsyncd_configured_ports
      port_config = "/etc/rsyncd.conf"
      port = port_config.scan(/^port ([0-9]+)/).flatten.map{|p| p.to_i}
      port = 873 unless port
    end

    def rsyncd_service
      service(node['rsyncd']['service'])
    end

    def rsyncd_config
      file(node['rsyncd']['config'])
    end

    def ran_recipe?(recipe)
      node.run_state[:seen_recipes].keys.include?(recipe)
    end

    def serving?(server)
      out = %x{rsync rsync://localhost}
      puts out
      if $?.success?
        matched = out.scan(/#{server}/)
      end
      return true unless matched.empty?
      false
    end

  end
end
