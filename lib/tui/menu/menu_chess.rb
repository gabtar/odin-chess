# frozen_string_literal: true

require 'curses'
require_relative '../../chess/chess'

# Menu object for a game of chess
#
# @attr options [Array] an array of commands for interacting with the Chess game
# @attr window [Window] a Curses.Window object where the menu will be rendered
class MenuChess
  attr_accessor :name, :options, :max_items

  include Curses

  def initialize(window, options = [])
    @name = 'New game menu'
    @options = options
    @active_index = 0
    @max_items = options.length - 1
    @window = window
  end

  # Displays the menu options inside the curses window
  def render
    @options.each_with_index do |element, index|
      name_length = element.name.length
      surround_spaces = ' ' * ((@window.maxx - name_length - 2) / 2)
      aditional_space = name_length.odd? ? ' ' : ''
      @window.setpos(index + 1, 1)
      @window.attrset(index == @active_index ? A_STANDOUT : A_NORMAL)
      @window.addstr("#{surround_spaces}#{element.name}#{surround_spaces}#{aditional_space}")
    end
    @window.refresh
  end

  # Updates to next option avaible in the menu. If +active_index+
  # is at the end, resets to the first element
  def next
    @active_index = @active_index >= @max_items ? 0 : @active_index + 1
    render
  end

  # Updates to previous option avaible in the menu. If +active_index+
  # is at the start, resets to the last element
  def previous
    @active_index = @active_index.zero? ? @max_items : @active_index - 1
    render
  end

  # Executes the current option action
  def execute
    @options[@active_index].execute
  end

  def add_option(option)
    @options << option
    @max_items = @options.length - 1
  end
end
