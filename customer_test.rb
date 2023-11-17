require "minitest/autorun"
require "active_support/all"
require_relative "customer"

class CustomerTest < Minitest::Test
  def test_statement
    customer = Customer.new("Customer Name")
    (1..5).each do |i|
      customer.add_rental(build_rental("Regular Movie #{i}", Movie::REGULAR, days_rented: i))
    end
    (1..6).each do |i|
      customer.add_rental(build_rental("New Release #{i}", Movie::NEW_RELEASE, days_rented: i))
    end
    (1..5).each do |i|
      customer.add_rental(build_rental("Children Movie #{i}", Movie::CHILDRENS, days_rented: i))
    end

    statement = customer.statement

    assert_equal(<<~EXPECTED_STATEMENT.squish, statement.squish, statement)
      Rental Record for Customer Name
        Regular Movie 1 2.0
        Regular Movie 2 2.0
        Regular Movie 3 3.5
        Regular Movie 4 5.0
        Regular Movie 5 6.5
        New Release 1 3.0
        New Release 2 6.0
        New Release 3 9.0
        New Release 4 12.0
        New Release 5 15.0
        New Release 6 18.0
        Children Movie 1  1.5
        Children Movie 2  1.5
        Children Movie 3  1.5
        Children Movie 4  3.0
        Children Movie 5  4.5
      Amount owed is 94.0
      You earned 21 frequent renter points
    EXPECTED_STATEMENT
  end

  def build_rental(title, price_code, days_rented:)
    movie = Movie.new(title, price_code)
    Rental.new(movie, days_rented)
  end
end
