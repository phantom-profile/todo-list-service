class PrepareDelivery
  TRUCKS = {
    gazel: 1000,
    kamaz: 3000
  }.freeze

  MESSAGES = {
    past_date: "Дата доставки уже прошла",
    no_address: "Нет адреса",
    no_car: "Нет машины"
  }.freeze
  SUCCESS = :ok
  FAIL = :error

  DeliveryPreparationError = Class.new(StandardError)

  def initialize(order:, address:, delivery_date:)
    @order = order
    @address = address
    @delivery_date = delivery_date
  end

  def perform
    @result = {
      truck: available_truck,
      weight: @order.weight,
      order_number: @order.id,
      address: @address,
      status: SUCCESS
    }

    validate!
    @result
  rescue DeliveryPreparationError => e
    @result[:status] = FAIL
    @result[:error] = e.message
    @result
  end

  def validate!
    raise DeliveryPreparationError, MESSAGES.fetch(:past_date) if @delivery_date < Time.current
    raise DeliveryPreparationError, @address.error_message if @address.invalid?
    raise DeliveryPreparationError, MESSAGES.fetch(:no_car) if available_truck.nil?
  end

  def available_truck
    return @_truck if defined? @_truck

    @_truck = TRUCKS.keys.find { |name| TRUCKS[name] > @order.weight }
  end
end

class Order
  def id
    'id'
  end

  def products
    [OpenStruct.new(weight: 20), OpenStruct.new(weight: 40)]
  end

  def weight
    @weight ||= products.sum(&:weight)
  end
end

class Address
  def city
    "Ростов-на-Дону"
  end

  def street
    "ул. Маршала Конюхова"
  end

  def house
    "д. 5"
  end

  def valid?
    [city, street, house].all?(&:present?)
  end

  def error_message
    attrs = {
      city: city,
      street: street,
      house: house
    }
    attrs.map { |name, value| "#{name} is blank" if value.blank? }.compact.join(', ')
  end

  def invalid?
    !valid?
  end
end

class MyTest
  def self.run!
    instance = new
    instance.positive_test
    instance.negative_test
    puts 'tests passed'
  end

  def positive_test
    result = PrepareDelivery.new(order: Order.new, address: Address.new, delivery_date: 1.day.from_now).perform
    raise 'test failed' if result[:status] != PrepareDelivery::SUCCESS
  end

  def negative_test
    result = PrepareDelivery.new(order: Order.new, address: Address.new, delivery_date: 1.day.ago).perform
    raise 'test failed' if result[:status] != PrepareDelivery::FAIL
  end
end

MyTest.run!
