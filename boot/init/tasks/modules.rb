class Tasks::Modules < Task
  MODULES_PATH = "/lib/modules"
  def initialize(*modules)
    add_dependency(:Files, MODULES_PATH)
    add_dependency(:Target, :Environment)
    @modules = modules
  end

  def run()
    @modules.each do |mod|
      begin
        $logger.info("Loading module #{mod}")
        System.run("modprobe", mod)
      rescue System::CommandError => e
        $logger.warn("Kernel module #{mod} failed to load. #{e.inspect}")
      end
    end
  end
end
