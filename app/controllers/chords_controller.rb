class ChordsController < ApplicationController
  before_action :load_chord_index
  before_action :validate_root, only: :show

  def index
    chord_list = []

    Constant::ChordCategory.includes(:chords).find_each do |category|
      chords = category.chords.map { |chord| generate_chord_hash(chord) }
      chord_list.push(category: category.name, chords:)
    end

    render json: chord_list
  end

  def show
    root = params[:root].to_s

    chord = Constant::Chord.find_by(path: params[:chord].to_s)

    notes = Constant::Interval.generate_relative_notes(chord.intervals, root)
    tones = chord.intervals.zip(notes).map { |interval, note| generate_tone_hash(interval, note) }
    enharmonic_root = Constant::Interval.handle_enharmonic_note(root)
    positions = Constant::ChordPosition.where(chord_id: chord.id, root: enharmonic_root).map { |position| generate_position_hash(position) }

    chord_info = {
      'name' => generate_chord_name(chord, root),
      'description' => edit_chord_info_description(chord.description, root),
      'tones' => tones,
      'positions' => positions
    }

    render json: chord_info
  end

  private

  def load_chord_index
    @chord_index = Constant::Chord.all.index_by(&:id)
  end

  def validate_root
    render status: :bad_request, json: { error: 'Invalid root parameter' } unless TONIC_NOTES.include?(params[:root])
  end

  def generate_chord_hash(chord)
    {
      'path' => chord.path,
      'quality' => chord.quality,
      'name' => chord.name,
      'description' => edit_chord_list_description(chord.description)
    }
  end

  def edit_chord_list_description(description)
    description.gsub(/\{chord_id:(\d+)\}/) do |_match|
      related_chord = @chord_index[$1.to_i]
      "#{related_chord.name}コード"
    end
  end

  def generate_tone_hash(interval, note)
    {
      'interval' => interval.name,
      'note' => note
    }
  end

  def generate_position_hash(position)
    {
      'string1' => position.str1,
      'string2' => position.str2,
      'string3' => position.str3,
      'string4' => position.str4,
      'string5' => position.str5,
      'string6' => position.str6
    }
  end

  def generate_chord_name(chord, root)
    case chord.quality
    when 'Maj'
      "#{format_note(root)}（#{format_note(root) + chord.name}）コード"
    when 'min'
      "#{format_note(root)}m（#{format_note(root) + chord.name}）コード"
    else
      "#{format_note(root) + chord.quality}（#{format_note(root) + chord.name}）コード"
    end
  end

  def edit_chord_info_description(description, root)
    description.gsub(/\{chord_id:(\d+)\}/) do |_match|
      related_chord = @chord_index[$1.to_i]

      "<a href=\"./#{related_chord.path}?root=#{root}\">" \
      "#{generate_chord_name(related_chord, root)}</a>".html_safe
    end
  end
end
