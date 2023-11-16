class Regular
  def price(rental)
    result = 0
    result += 2
    result += (rental.days_rented - 2) * 1.5 if rental.days_rented > 2
    result
  end

  def frequent_renter_points(rental)
    1
  end
end

class NewRelease
  def price(rental)
    rental.days_rented * 3
  end

  def frequent_renter_points(rental)
    rental.days_rented > 1 ? 2 : 1
  end
end

class Childrens
  def price(rental)
    result = 0
    result += 1.5
    result += (rental.days_rented - 3) * 1.5 if rental.days_rented > 3
    result
  end

  def frequent_renter_points(rental)
    1
  end
end

class Movie < Struct.new(:title, :price_code)
  REGULAR = Regular.new
  NEW_RELEASE = NewRelease.new
  CHILDRENS = Childrens.new
end

class Rental < Struct.new(:movie, :days_rented)
end

class Customer < Struct.new(:name, :rentals)
  def initialize(name)
    super(name, [])
  end

  def add_rental(arg)
    rentals << arg
  end

  def statement
    total_amount, frequent_renter_points = 0, 0
    result = "Rental Record for #{name}\n"
    rentals.each do |rental|
      this_amount = rental.movie.price_code.price(rental)
      frequent_renter_points += rental.movie.price_code.frequent_renter_points(rental)
      result += "\t#{rental.movie.title}\t#{this_amount}\n"
      total_amount += this_amount
    end
    result += "Amount owed is #{total_amount}\n"
    result += "You earned #{frequent_renter_points} frequent renter points"
    result
  end
end
