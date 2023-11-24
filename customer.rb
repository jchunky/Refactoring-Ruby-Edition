class Movie < Struct.new(:title, :price_code)
  REGULAR = 0
  NEW_RELEASE = 1
  CHILDRENS = 2
end

class Rental < Struct.new(:movie, :days_rented)
  def price
    case movie.price_code
    when Movie::REGULAR
      days_rented > 2 ? 2 + ((days_rented - 2) * 1.5) : 2
    when Movie::NEW_RELEASE
      days_rented * 3
    when Movie::CHILDRENS
      days_rented > 3 ? 1.5 + ((days_rented - 3) * 1.5) : 1.5
    end
  end

  def frequent_renter_points
    movie.price_code == Movie::NEW_RELEASE && days_rented > 1 ? 2 : 1
  end
end

class Customer < Struct.new(:name, :rentals)
  def initialize(name)
    super(name, [])
  end

  def add_rental(rental)
    rentals << rental
  end

  def statement
    result = "Rental Record for #{name}\n"
    rentals.each do |rental|
      result += "\t#{rental.movie.title}\t#{rental.price}\n"
    end
    result += "Amount owed is #{total_amount}\n"
    result += "You earned #{frequent_renter_points} frequent renter points"
    result
  end

  private

  def total_amount
    rentals.sum(&:price)
  end

  def frequent_renter_points
    rentals.sum(&:frequent_renter_points)
  end
end
