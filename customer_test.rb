require "minitest/autorun"
require "active_support/all"
require_relative "customer"

class CustomerTest < Minitest::Test
  def test_statement
    customer = Customer.new("John Smith")
    (1..5).each do |i|
      customer.add_rental(build_rental("Regular Movie - #{i} days rented", Movie::REGULAR, days_rented: i))
    end
    (1..6).each do |i|
      customer.add_rental(build_rental("New Release - #{i} days rented", Movie::NEW_RELEASE, days_rented: i))
    end
    (1..5).each do |i|
      customer.add_rental(build_rental("Children Movie - #{i} days rented", Movie::CHILDRENS, days_rented: i))
    end

    statement = customer.statement

    assert_equal(<<~EXPECTED_STATEMENT.squish, statement.squish, statement)
      Rental Record for John Smith
        Regular Movie - 1 days rented 2
        Regular Movie - 2 days rented 2
        Regular Movie - 3 days rented 3.5
        Regular Movie - 4 days rented 5.0
        Regular Movie - 5 days rented 6.5
        New Release - 1 days rented 3
        New Release - 2 days rented 6
        New Release - 3 days rented 9
        New Release - 4 days rented 12
        New Release - 5 days rented 15
        New Release - 6 days rented 18
        Children Movie - 1 days rented  1.5
        Children Movie - 2 days rented  1.5
        Children Movie - 3 days rented  1.5
        Children Movie - 4 days rented  3.0
        Children Movie - 5 days rented  4.5
      Amount owed is 94.0
      You earned 21 frequent renter points
    EXPECTED_STATEMENT
  end

  def build_rental(title, price_code, days_rented:)
    movie = Movie.new(title, price_code)
    Rental.new(movie, days_rented)
  end
end
