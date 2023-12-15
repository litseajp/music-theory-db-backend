class ScalesController < ApplicationController
  before_action :load_scale_index
  before_action :validate_tonic, only: :show

  def index
    scale_list = []

    Constant::ScaleCategory.includes(:scales).find_each do |category|
      scales = category.scales.map { |scale| generate_scale_hash(scale) }
      scale_list.push(category: category.name, scales:)
    end

    render json: scale_list
  end

  def show
    tonic = params[:tonic]

    scale = Constant::Scale.includes(scale_tones: %i[interval tone_type]).find_by(path: params[:scale].to_s)

    notes = Constant::ScaleTone.generate_scale_notes(scale.scale_tones, tonic, scale.scale_category_id, scale.path)
    tones = scale.scale_tones.map.with_index { |tone, idx| generate_tone_hash(tone, notes[idx]) }

    scale_info = {
      'name' => format_note(tonic) + format_accidental(scale.name),
      'description' => edit_scale_info_description(scale.description, tones),
      'tones' => tones
    }

    render json: scale_info
  end

  private

  def load_scale_index
    @scale_index = Constant::Scale.all.index_by(&:id)
  end

  def validate_tonic
    render status: :bad_request, json: { error: 'Invalid tonic parameter' } unless TONIC_NOTES.include?(params[:tonic])
  end

  def generate_scale_hash(scale)
    {
      'path' => scale.path,
      'name' => format_accidental(scale.name),
      'description' => edit_scale_list_description(scale.description)
    }
  end

  def format_accidental(str)
    str.tr('#b', '♯♭')
  end

  def edit_scale_list_description(description)
    edited_description = description.gsub(/\[\d\]/, '')

    edited_description.gsub!(/\{interval:(\d),scale_id:(\d+)\}/) do |_match|
      related_scale = @scale_index[$2.to_i]
      related_scale.name
    end

    format_accidental(edited_description)
  end

  def generate_tone_hash(tone, note)
    {
      'interval' => tone.interval.name,
      'note' => note,
      'tone_type' => tone.tone_type.name
    }
  end

  def format_note(note)
    note.length == 1 ? note.upcase : note.slice(0).upcase + SYMBOLS[note.slice(1..-1).to_sym]
  end

  def edit_scale_info_description(description, tones)
    edited_description = format_accidental(description).gsub(/\[(\d)\]/) do |_match|
      format_note(tones[$1.to_i]['note'])
    end

    edited_description.gsub(/\{interval:(\d),scale_id:(\d+)\}/) do |_match|
      related_scale_tonic = tones[$1.to_i]['note']
      related_scale = @scale_index[$2.to_i]

      if TONIC_NOTES.include?(related_scale_tonic)
        "<a href=\"./#{related_scale.path}?tonic=#{related_scale_tonic}\">" \
        "#{format_note(related_scale_tonic)}#{format_accidental(related_scale.name)}</a>".html_safe
      else
        "#{format_note(related_scale_tonic)}#{format_accidental(related_scale.name)}"
      end
    end
  end
end
