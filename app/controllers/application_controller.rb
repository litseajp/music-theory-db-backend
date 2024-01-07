class ApplicationController < ActionController::API
  def format_note(note)
    note.length == 1 ? note.upcase : note.slice(0).upcase + SYMBOLS[note.slice(1..-1).to_sym]
  end
end
