Fasti.configure do |config|
  config.format = :quarter
  config.start_of_week = :monday
  config.country = :jp

  config.style = {
    sunday: {
      foreground: :red,
      bold: true
    },
    saturday: {
      foreground: :blue,
      bold: true
    },
    holiday: {
      foreground: :red,
      bold: true
    },

    today: {
      inverse: true
    }
  }
end
