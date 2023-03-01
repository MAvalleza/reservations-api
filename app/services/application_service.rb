class ApplicationService
  def self.run(*args, &block)
    new(*args, &block).perform
  end
end
