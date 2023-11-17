class RegularMovie
  def price(rental)
    ((rental.days_rented * 1.5) - 1).clamp(2..)
  end

  def frequent_renter_points(rental)
    1
  end
end

class NewReleaseMovie
  def price(rental)
    rental.days_rented * 3
  end

  def frequent_renter_points(rental)
    rental.days_rented > 1 ? 2 : 1
  end
end

class ChildrensMovie
  def price(rental)
    ((rental.days_rented * 1.5) - 3).clamp(1.5..)
  end

  def frequent_renter_points(rental)
    1
  end
end

class Movie < Struct.new(:title, :movie_category)
  REGULAR = RegularMovie.new
  NEW_RELEASE = NewReleaseMovie.new
  CHILDRENS = ChildrensMovie.new

  delegate :price, :frequent_renter_points, to: :movie_category
end

class Rental < Struct.new(:movie, :days_rented)
  delegate :title, to: :movie

  def price
    movie.price(self)
  end

  def frequent_renter_points
    movie.frequent_renter_points(self)
  end
end

class Statement < Struct.new(:customer)
  delegate :name, to: :customer, prefix: true
  delegate :rentals, to: :customer

  def total_amount
    rentals.sum(&:price)
  end

  def frequent_renter_points
    rentals.sum(&:frequent_renter_points)
  end
end

class StatementFormatter < SimpleDelegator
  def to_s
    [
      "Rental Record for #{customer_name}",
      rentals.map(&method(:format_rental)),
      "Amount owed is #{total_amount}",
      "You earned #{frequent_renter_points} frequent renter points",
    ].join("\n")
  end

  private

  def format_rental(rental)
    "\t#{rental.title}\t#{rental.price}"
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
    StatementFormatter.new(Statement.new(self)).to_s
  end
end
