require_relative 'spec_helper'

module TeamcityRestClient
  
  describe "filters" do
    before :each do
      @build_type_a = stub('build type a', :id => "bt1", :name => "a" )
      @build_type_b = stub('build type b', :id => "bt2", :name => "b" )
      @build_type_c = stub('build type c', :id => "bt3", :name => "c" )
    end

    describe IncludeAllFilter do
      before :each do
        @filter = IncludeAllFilter.new
      end

      it "should retain everything and have no misses" do
        @filter.retain?(@build_type_a).should be_true
        @filter.retain?(@build_type_b).should be_true
        @filter.retain?(@build_type_c).should be_true
        @filter.misses.should be_empty
      end
    end
    
    describe ExcludeNoneFilter do
      before :each do
        @filter = ExcludeNoneFilter.new
      end

      it "should retain everything have no misses" do
        @filter.retain?(@build_type_a).should be_true
        @filter.retain?(@build_type_b).should be_true
        @filter.retain?(@build_type_c).should be_true
        @filter.misses.should be_empty
      end
    end
    
    describe IncludeFilter do      
      describe "including 1 thing" do
        before :each do
          @filter = IncludeFilter.new "a"
        end

        it "should retain when there is a match by name" do
          @filter.retain?(@build_type_a).should be_true
        end

        it "should not retain when there is not a match" do
          @filter.retain?(@build_type_b).should be_false
        end
      end
      
      describe "include many things" do
        before :each do
          @filter = IncludeFilter.new ["a", "bt3", "non-existant"]
        end

        it "should retain when there is a match by name" do
          @filter.retain?(@build_type_a).should be_true
        end

        it "should retain when there is a match by id" do
          @filter.retain?(@build_type_c).should be_true
        end

        it "should not retain when there is not a match" do
          @filter.retain?(@build_type_b).should be_false
        end

        it "should be able to report things that didnt match" do
          @filter.retain?(@build_type_a)
          @filter.misses.should == ["bt3", "non-existant"]
        end
      end
    end
    
    describe ExcludeFilter do
      describe "excluding 1 thing" do
        before :each do
          @filter = ExcludeFilter.new "a"
        end

        it "should not retain when there is a match by name" do
          @filter.retain?(@build_type_a).should be_false
        end

        it "should retain when there is not a match" do
          @filter.retain?(@build_type_b).should be_true
        end
      end
      
      describe "exclude many things" do
        before :each do
          @filter = ExcludeFilter.new ["a", "bt3", "non-existant"]
        end

        it "should not retain there is a match by name" do
          @filter.retain?(@build_type_a).should be_false
        end

        it "should not retain there is a match by id" do
          @filter.retain?(@build_type_c).should be_false
        end

        it "should retain when there is not a match" do
          @filter.retain?(@build_type_b).should be_true
        end

        it "should be able to report things that didnt match" do
          @filter.retain?(@build_type_a)
          @filter.misses.should == ["bt3", "non-existant"]
        end
      end
    end
  end
  
  describe Project do
    before :each do
      @bt11 = stub('bt11', :id => "bt11", :name => "project1-build1", :project_id => "project1")
      @bt12 = stub('bt12', :id => "bt12", :name => "project1-build2", :project_id => "project1")
      @bt13 = stub('bt13', :id => "bt13", :name => "project1-build3", :project_id => "project1")
      @bt14 = stub('bt14', :id => "bt14", :name => "project1-build4-never-been-built", :project_id => "project1")
      @bt21 = stub('bt21', :id => "bt21", :name => "project2-build1", :project_id => "project2")
    
      @bt11_1 = stub('bt11_1', :id => "1", :build_type_id => "bt11")
      @bt11_2 = stub('bt11_2', :id => "2", :build_type_id => "bt11")
      @bt12_33 = stub('bt12_33', :id => "33", :build_type_id => "bt12")
      @bt13_44 = stub('bt13_44', :id => "44", :build_type_id => "bt13")
      @bt21_666 = stub('bt21_666', :id => "666", :build_type_id => "bt21")
    
      @tc = mock('teamcity', :build_types => [@bt11, @bt12, @bt13, @bt14, @bt21], :builds => [@bt11_1, @bt11_2, @bt12_33, @bt13_44, @bt21_666])
      @project1 = Project.new @tc, "Project 1", "project1", "http://www.example.com"
    end
  
    describe "asking it for it's build types" do
      before :each do
        @build_types = @project1.build_types
      end
    
      it "should have only those for project 1" do
        @build_types.should == [@bt11, @bt12, @bt13, @bt14]
      end
    end

    describe "asking it for it's build types with filtering" do
      describe "include" do
        it "should match by single project name" do
          @project1.build_types({ :include => "project1-build2" }).should == [@bt12]
        end
        it "should match by single project id" do
          @project1.build_types({ :include => "bt11" }).should == [@bt11]
        end
        it "should match by multiple project id and name" do
          @project1.build_types({ :include => ["bt11","project1-build2"] }).should == [@bt11, @bt12]
        end
      end
      
      describe "exclude" do
        it "should match by single project name" do
          @project1.build_types({ :exclude => "project1-build2" }).should == [@bt11, @bt13, @bt14]
        end
        it "should match by single project id" do
          @project1.build_types({ :exclude => "bt11" }).should == [@bt12, @bt13, @bt14]
        end
        it "should match by multiple project id and name" do
          @project1.build_types({ :exclude => ["bt11","project1-build2"] }).should == [@bt13, @bt14]
        end
      end
      
      describe "include and exclude" do
        it "should allow both, but its a bit pointless" do
          @project1.build_types({ :include => ["bt11","project1-build2"], :exclude => ["bt11"]}).should == [@bt12]
        end
      end
      
      describe "when an include fails to match as incorrectly typed" do
        it "should raise exception" do
          lambda { @project1.build_types({ :include => ["bt11", "nonsense1", "nonsense2"]}) }.should raise_error 'Failed to find a match for build type(s) ["nonsense1", "nonsense2"]'
        end
      end
      
      describe "when an exclude fails to match as incorrectly typed" do
        it "should raise exception" do
          lambda { @project1.build_types({ :exclude => ["bt11", "nonsense1", "nonsense2"]}) }.should raise_error 'Failed to find a match for build type(s) ["nonsense1", "nonsense2"]'
        end
      end
    end
    
    describe "asking it for it's builds" do
      describe 'with no options' do
        before :each do
          @tc.should_receive(:builds).with({}).and_return([@bt11_1, @bt11_2, @bt12_33, @bt13_44])
          @builds = @project1.builds
        end

        it "should have only builds for project 1" do
          @builds.should == [@bt11_1, @bt11_2, @bt12_33, @bt13_44]
        end
      end
      
      describe "with some other options" do
        before :each do
          @options = {:running => true}
          @tc.should_receive(:builds).with(@options).and_return([@bt11_1, @bt11_2, @bt12_33, @bt13_44])
          @builds = @project1.builds @options
        end
        
        it 'should pass through the options to tc' do
          @builds.should == [@bt11_1, @bt11_2, @bt12_33, @bt13_44]
        end
      end
    end
    
    describe "latest_builds" do
      before :each do
        @bt11.stub(:latest_build).and_return(@bt11_2)
        @bt12.stub(:latest_build).and_return(@bt12_33)
        @bt13.stub(:latest_build).and_return(@bt13_44)
        @bt14.stub(:latest_build).and_return(nil)
      end
      
      describe "for all builds in project" do
        before :each do
          @latest_builds = @project1.latest_builds
        end

        it "should get latest" do
          @latest_builds.should == [@bt11_2, @bt12_33, @bt13_44]
        end
      end
      
      describe "with an include filter specified" do
        before :each do
          @latest_builds = @project1.latest_builds :include => @bt11.id
        end

        it "should get latest only for that filter" do
          @latest_builds.should == [@bt11_2]
        end
      end
      
      describe "with an exclude filter specified" do
        before :each do
          @latest_builds = @project1.latest_builds :exclude => @bt11.id
        end

        it "should get latest only for that filter" do
          @latest_builds.should == [@bt12_33, @bt13_44]
        end
      end
    end
  end

  describe HttpBasicAuthentication do
    before :each do
      @openuri_options = { :proxy => 'http://proxy:9999' }
      @host, @port, @user, @password = "auth.example.com", 2233, "john", "wayne"
      @auth = HttpBasicAuthentication.new @host, @port, @user, @password, @openuri_options
      @io = stub(:read => "<xml/>")
    end
    
    describe "url" do
      it "should add /httpAuth to path" do
        @auth.url("/something").should == "http://auth.example.com:2233/httpAuth/something"
      end
      
      it "should not add /httpAuth to path when already there" do
        @auth.url("/httpAuth/something").should == "http://auth.example.com:2233/httpAuth/something"
      end
      
      it "should create query string from params" do
        @auth.url("/overhere", {:id => "1", :name => 'betty'}).should == "http://auth.example.com:2233/httpAuth/overhere?id=1&name=betty"
      end
    end
    
    describe "get" do
      it "should call open with http basic auth options, and openuri option" do
        path, options = "/something", {:id => 1}
        url = "http://localhost:1324"
        @auth.should_receive(:url).with(path, options).and_return url
        @auth.should_receive(:open).with(url, {:http_basic_authentication=>[@user, @password], :proxy => 'http://proxy:9999'}).and_return(@io)
        @auth.get(path, options)
      end
    end
  end
  
  describe Open do
    before :each do
      @host, @port = "auth.example.com", 2233
      @openuri_options = { :proxy => 'http://localhost:1234' }
      @auth = Open.new @host, @port, @openuri_options
      @io = stub(:read => "<xml/>")
    end
    
    describe "url" do
      it "should create valid url" do
        @auth.url("/something").should == "http://auth.example.com:2233/something"
      end
      
      it "should create query string from params" do
        @auth.url("/overhere", {:id => "2", :name => 'boo'}).should == "http://auth.example.com:2233/overhere?id=2&name=boo"
      end
    end
    
    describe "get" do
      it "should call open with no auth options" do
        path, options = "/something", {:id => 1}
        url = "http://localhost:1324"
        @auth.should_receive(:url).with(path, options).and_return url
        @auth.should_receive(:open).with(url, @openuri_options).and_return(@io)
        @auth.get(path, options)
      end
    end
  end
  
  describe BuildType do
    before :each do
      @tc = mock('teamcity')
      @id, @name, @href, @project_name, @project_id, @web_url = "bt123", "build 123", "project 1", "project1", "http://www.example.com/something"
      @build_type = BuildType.new @tc, @id, @name, @href, @project_name, @project_id, @web_url
    end
    
    describe "latest_build" do
      describe "when there has been at least 1 build" do
        before :each do
          @build = mock('build')
          @tc.should_receive(:builds).with(:buildType => "id:bt123", :count => 1).and_return [@build]
        end
        
        it "should ask teamcity, and return the single build" do
          @build_type.latest_build.should == @build
        end
      end
      
      describe "when there hasnt ever been a build" do
        before :each do
          @tc.should_receive(:builds).with(:buildType => "id:bt123", :count => 1).and_return []
        end
        
        it "should ask teamcity, and get no build back" do
          @build_type.latest_build.should   be_nil
        end
      end
    end
    
    describe "builds" do
      before :each do
        @build1 = mock('build1')
        @build2 = mock('build2')
        @tc.should_receive(:builds).with({:buildType => "id:bt123", :running => true, :somethingelse => 'here'}).and_return [@build1, @build2]
      end
      it "should ask teamcity" do
        @build_type.builds({ :running => true, :somethingelse => 'here' }).should == [@build1, @build2]
      end
    end
  end
end

describe Teamcity do
  before :all do
    @sample_projects_xml = sample_xml "projects"
    @sample_builds_xml = sample_xml "builds"
    @sample_build_types_xml = sample_xml "buildTypes"
  end
  
  describe "specifying username and password" do
    before :each do
      @host, @port, @user, @password = "authtc.example.com", 8877, "bob", "marley"
      @proxy = 'http://dog:8080'
      @authentication = mock('authentication')
      TeamcityRestClient::HttpBasicAuthentication.should_receive(:new).with(@host, @port, @user, @password, { :proxy => @proxy }).and_return(@authentication)
      @tc = Teamcity.new @host, @port, :user => @user, :password => @password, :proxy => @proxy
    end
    
    it "should create HttpBasicAuthentication, passing through the options" do
      @tc.authentication.should === @authentication
    end
  end

  describe "specifying no username and password" do
    before :each do
      @host, @port = "authtc.example.com", 8877
      @options = { :proxy => 'cat' }
      @authentication = mock('authentication')
      TeamcityRestClient::Open.should_receive(:new).with(@host, @port, @options).and_return(@authentication)
      @tc = Teamcity.new @host, @port, @options
    end
    
    it "should create Open authentication" do
      @tc.authentication.should === @authentication
    end
  end
  
  describe "finding a specific project" do
    before :each do
      @tc = Teamcity.new "tc.example.com", 5678
      @project1 = stub('project1', :name => "First Project", :id => "project1")
      @project456 = stub('project456', :name => "Project 456", :id => "project456")
      @project3877 = stub('project3877', :name => "Some other project with a big number", :id => "project3877")
      @tc.stub(:projects).and_return [@project1, @project456, @project3877]
    end
    
    describe "by project name" do
      it "should return project with name First Project" do
        @tc.project("First Project").should === @project1
      end
      
      it "should return project with name Some other project with a big number" do
        @tc.project("Some other project with a big number").should === @project3877
      end
      
      it "should blowup when the project name doesnt exist" do
        lambda { @tc.project("bollocks") }.should raise_error "Sorry, cannot find project with name or id 'bollocks'"
      end
    end
    
    describe "by project id" do
      it "should return project with id project456" do
        @tc.project("project456").should === @project456
      end
      
      it "should return project with id project3877" do
        @tc.project("project3877").should === @project3877
      end
    end
  end
  
  describe "when authentication fails" do
    before :each do
      @host, @port = "fail.example.com", 1234
      @authentication = TeamcityRestClient::Open.new @host, @port
      TeamcityRestClient::Open.should_receive(:new).and_return(@authentication)
      fail_html = <<HTML

      <!DOCTYPE html>
      <html id="htmlId">
      something
      </html>  
HTML
      
      @authentication.stub(:get).and_return(fail_html)
      @tc = Teamcity.new @host, @port
    end
    
    it "should raise an error" do
      lambda { @tc.build_types }.should raise_error "Teamcity returned html, perhaps you need to use authentication??"
    end
  end
  
  describe "parsing xml feeds" do
    before :each do
      @host, @port, @user, @password = "tc.example.com", 1234, "user", "password"
      @authentication = TeamcityRestClient::HttpBasicAuthentication.new @host, @port, @user, @password
    end
    
    describe "projects" do
      before :each do
        xml = <<XML
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<projects>
  <project name="Amazon API client" id="project54" href="/httpAuth/app/rest/projects/id:project54"/>
  <project name="Apache Ant" id="project28" href="/httpAuth/app/rest/projects/id:project28"/>
</projects>        
XML
        @authentication.should_receive(:get).with("/app/rest/projects", {}).and_return(xml)
        TeamcityRestClient::HttpBasicAuthentication.should_receive(:new).and_return(@authentication)
        @tc = Teamcity.new @host, @port, { :user => @user, :password => @password }
        @projects = @tc.projects
      end
      
      it "should have 2" do
        @projects.length.should == 2
      end
      
      it "should have amazon project" do
        amazon = @projects[0]
        amazon.name.should == "Amazon API client"
        amazon.id.should == "project54"
        amazon.href.should == "http://tc.example.com:1234/httpAuth/app/rest/projects/id:project54"
      end
      
      it "should have ant project" do
        ant = @projects[1]
        ant.name.should == "Apache Ant"
        ant.id.should == "project28"
        ant.href.should == "http://tc.example.com:1234/httpAuth/app/rest/projects/id:project28"
      end
    end

    describe "buildTypes" do
      before :each do
        xml = <<XML
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<buildTypes>
  <buildType id="bt297" name="Build" href="/httpAuth/app/rest/buildTypes/id:bt297" 
    projectName="Amazon API client" projectId="project54" webUrl="http://teamcity.jetbrains.com/viewType.html?buildTypeId=bt297"/>
  <buildType id="bt296" name="Download missing jar" href="/httpAuth/app/rest/buildTypes/id:bt296" 
    projectName="Amazon API client" projectId="project54" webUrl="http://teamcity.jetbrains.com/viewType.html?buildTypeId=bt296"/>
</buildTypes>      
XML
        @authentication.should_receive(:get).with("/app/rest/buildTypes", {}).and_return(xml)
        TeamcityRestClient::HttpBasicAuthentication.should_receive(:new).and_return(@authentication)
        @tc = Teamcity.new @host, @port, :user => @user, :password => @password
        @build_types = @tc.build_types
      end
      
      it 'should have 2' do
        @build_types.length.should == 2
      end
      
      it "should have build bt297" do
        bt297 = @build_types[0]
        bt297.id.should == "bt297"
        bt297.name.should == "Build"
        bt297.href.should == "http://tc.example.com:1234/httpAuth/app/rest/buildTypes/id:bt297"
        bt297.project_name.should == "Amazon API client"
        bt297.project_id.should == "project54"
        bt297.web_url.should == "http://teamcity.jetbrains.com/viewType.html?buildTypeId=bt297"
      end
      
      it "should have build bt296" do
        bt296 = @build_types[1]
        bt296.id.should == "bt296"
        bt296.name.should == "Download missing jar"
        bt296.href.should == "http://tc.example.com:1234/httpAuth/app/rest/buildTypes/id:bt296"
        bt296.project_name.should == "Amazon API client"
        bt296.project_id.should == "project54"
        bt296.web_url.should == "http://teamcity.jetbrains.com/viewType.html?buildTypeId=bt296"
      end
    end
    
    describe "builds" do
      describe "when there hasnt been any builds for configuration" do
        before :each do
          xml = <<XML
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<builds count="0"/>          
XML
        end
        
        pending "it should return an empty array" 
        
      end
      
      describe "with options specified" do
          before :each do
            xml = <<XML
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<builds nextHref="/app/rest/builds?count=100&amp;start=100" count="100">
    <build id="56264" number="126" status="FAILURE" buildTypeId="bt212" href="/httpAuth/app/rest/builds/id:56264" 
      webUrl="http://teamcity.jetbrains.com/viewLog.html?buildId=56264&buildTypeId=bt212"/>
</builds>
XML
            @options = {:buildType => "id:bt212", :count => 1}
            @authentication.should_receive(:get).with("/app/rest/builds", @options).and_return(xml)
            TeamcityRestClient::HttpBasicAuthentication.should_receive(:new).and_return(@authentication)
            @tc = Teamcity.new @host, @port, :user => @user, :password => @password
            @builds = @tc.builds @options
          end

          it "should have only 1 build as a result" do
            @builds.length.should == 1
          end
      end
      
      describe "TeamCity Enterprise 5.1.2" do
          before :each do
            xml = <<XML
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<builds nextHref="/app/rest/builds?count=100&amp;start=100" count="100">
    <build id="56264" number="126" status="FAILURE" buildTypeId="bt212" href="/httpAuth/app/rest/builds/id:56264" 
      webUrl="http://teamcity.jetbrains.com/viewLog.html?buildId=56264&buildTypeId=bt212"/>
</builds>
XML
            @authentication.should_receive(:get).with("/app/rest/builds", {}).and_return(xml)
            TeamcityRestClient::HttpBasicAuthentication.should_receive(:new).and_return(@authentication)
            @tc = Teamcity.new @host, @port, :user => @user, :password => @password
            @builds = @tc.builds
          end

          it "should have 1" do
            @builds.length.should == 1
          end

          it "should have build 56264" do
            build = @builds[0]
            build.id.should == "56264"
            build.number.should == "126"
            build.status.should == :FAILURE
            build.success?.should == false
            build.build_type_id.should == "bt212"
            build.start_date.should == ""
            build.href.should == "http://tc.example.com:1234/httpAuth/app/rest/builds/id:56264"
            build.web_url.should == "http://teamcity.jetbrains.com/viewLog.html?buildId=56264&buildTypeId=bt212"
          end
      end
      
      describe "TeamCity Enterprise 6.5.4" do
          before :each do
            xml = <<XML
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<builds nextHref="/app/rest/builds?count=100&amp;start=100" count="100">
    <build id="56264" number="126" status="FAILURE" buildTypeId="bt212" startDate="20111021T123714+0400" href="/app/rest/builds/id:56264" 
      webUrl="http://teamcity.jetbrains.com/viewLog.html?buildId=56264&buildTypeId=bt212"/>
    <build id="56262" number="568" status="SUCCESS" buildTypeId="bt213" startDate="20111021T120639+0400" href="/app/rest/builds/id:56262" 
      webUrl="http://teamcity.jetbrains.com/viewLog.html?buildId=56262&buildTypeId=bt213"/>
</builds>
XML
            @authentication.should_receive(:get).with("/app/rest/builds", {}).and_return(xml)
            TeamcityRestClient::HttpBasicAuthentication.should_receive(:new).and_return(@authentication)
            @tc = Teamcity.new @host, @port, :user => @user, :password => @password
            @builds = @tc.builds
          end

          it "should have 2" do
            @builds.length.should == 2
          end

          it "should have build 56264" do
            build = @builds[0]
            build.id.should == "56264"
            build.number.should == "126"
            build.status.should == :FAILURE
            build.success?.should == false
            build.build_type_id.should == "bt212"
            build.start_date.should == "20111021T123714+0400"
            build.href.should == "http://tc.example.com:1234/httpAuth/app/rest/builds/id:56264"
            build.web_url.should == "http://teamcity.jetbrains.com/viewLog.html?buildId=56264&buildTypeId=bt212"
          end

          it "should have build 56262" do
            build = @builds[1]
            build.id.should == "56262"
            build.number.should == "568"
            build.status.should == :SUCCESS
            build.success?.should == true
            build.build_type_id.should == "bt213"
            build.start_date.should == "20111021T120639+0400"
            build.href.should == "http://tc.example.com:1234/httpAuth/app/rest/builds/id:56262"
            build.web_url.should == "http://teamcity.jetbrains.com/viewLog.html?buildId=56262&buildTypeId=bt213"
          end
        end
    end
  end
end
