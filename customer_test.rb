require "minitest/autorun"
require "active_support/all"
require_relative "customer"

class CustomerTest < Minitest::Test
  def test_statement
    customer = Customer.new("John")
    customer.add_rental(build_rental("The Scarlet Pimpernel", Movie::REGULAR, days_rented: 2))
    customer.add_rental(build_rental("Chinatown", Movie::REGULAR, days_rented: 3))
    customer.add_rental(build_rental("Batman", Movie::NEW_RELEASE, days_rented: 1))
    customer.add_rental(build_rental("Dune", Movie::NEW_RELEASE, days_rented: 2))
    customer.add_rental(build_rental("Toy Story", Movie::CHILDRENS, days_rented: 3))
    customer.add_rental(build_rental("Jumanji", Movie::CHILDRENS, days_rented: 4))

    statement = customer.statement

    assert_equal(<<~EXPECTED_STATEMENT.squish, statement.squish, statement)
      Rental Record for John
        The Scarlet Pimpernel 2.0
        Chinatown 3.5
        Batman  3
        Dune  6
        Toy Story 1.5
        Jumanji 3.0
      Amount owed is 19.0
      You earned 7 frequent renter points
    EXPECTED_STATEMENT
  end

  def build_rental(title, price_code, days_rented:)
    movie = Movie.new(title, price_code)
    Rental.new(movie, days_rented)
  end
end
