# app/services/number_generator_service.rb
class NumberGeneratorService
  def initialize(application = nil, chat = nil)
    @application = application
    @chat = chat
  end
end
