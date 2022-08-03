class Project < ApplicationRecord
  include Sieves::Filterable

  filterable do
    columns :name, :status, :date, :rate
  end
end
