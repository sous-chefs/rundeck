require 'json'

def rundeck_stubs(node, server)
  allow(Chef::EncryptedDataBagItem).to receive(:load_secret).with(/rundeck/).and_return('1234')
  # stub all possible data bag calls based on fixtures/data_bags
  # https://github.com/sethvargo/chefspec#data-bag--data-bag-item
  Dir[File.join(File.dirname(__FILE__), 'fixtures/data_bags/*')].each do |bag_dir|
    bag_name = File.basename(bag_dir)
    bag_data = {} # item names => item data
    item_files = Dir[File.join(bag_dir, '*.json')]
    stub_data_bag(bag_name).and_return(item_files.map { |f| File.basename(f, '.json') })
    item_files.each do |item_file|
      item_name = File.basename(item_file, '.json')
      item_data = JSON.parse(File.read(item_file))
      bag_data[item_name] = item_data
      stub_data_bag_item(bag_name, item_name).and_return(item_data)
      allow(Chef::EncryptedDataBagItem).to receive(:load).with(bag_name, item_name, '1234').and_return(item_data)
    end
    server.create_data_bag(bag_name, bag_data)
  end

  stub_command(/rd-jobs/).and_return('')
  stub_command(/\/usr\/sbin\/httpd/).and_return('')
  stub_command(/bundle check/).and_return('')
end
