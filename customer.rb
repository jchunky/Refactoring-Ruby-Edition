class RegularPrice
  def price(rental)
    if rental.days_rented > 2
      2 + ((rental.days_rented - 2) * 1.5)
    else
      2
    end
  end

  def frequent_renter_points(rental)
    1
  end
end

class NewReleasePrice
  def price(rental)
    rental.days_rented * 3
  end

  def frequent_renter_points(rental)
    # add bonus for a two day new release rental
    if rental.days_rented > 1
      2
    else
      1
    end
  end
end

class ChildrensPrice
  def price(rental)
    if rental.days_rented > 3
      1.5 + ((rental.days_rented - 3) * 1.5) if rental.days_rented > 3
    else
      1.5
    end
  end

  def frequent_renter_points(rental)
    1
  end
end

class Movie < Struct.new(:title, :price_code)
  REGULAR = RegularPrice.new
  NEW_RELEASE = NewReleasePrice.new
  CHILDRENS = ChildrensPrice.new
end

class Rental < Struct.new(:movie, :days_rented)
  def price
    movie.price_code.price(self)
  end

  def frequent_renter_points
    movie.price_code.frequent_renter_points(self)
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
      this_amount = rental.price

      # show figures for this rental
      result += "\t#{rental.movie.title}\t#{this_amount}\n"
    end
    # add footer lines
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
