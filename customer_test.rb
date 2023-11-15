require "minitest/autorun"
require "active_support/all"
require_relative "customer"

class CustomerTest < Minitest::Test
  def test_statement
    customer = Customer.new("John")
    customer.add_rental(build_rental("The Scarlet Pimpernel", Movie::REGULAR, days_rented: 1))

    statement = customer.statement

    assert_equal(<<~EXPECTED_STATEMENT.squish, statement.squish, statement)
      Rental Record for John
        The Scarlet Pimpernel 2
      Amount owed is 2
      You earned 1 frequent renter points
    EXPECTED_STATEMENT
  end

  def build_rental(title, price_code, days_rented:)
    movie = Movie.new(title, price_code)
    Rental.new(movie, days_rented)
  end
end
