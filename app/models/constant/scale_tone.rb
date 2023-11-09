class Constant::ScaleTone < ApplicationRecord
  belongs_to :accidental
  belongs_to :interval
  belongs_to :tone_type

  def self.generate_scale_notes(tones, tonic, scale_category_id, path)
    notes = tones.map { |tone| calc_relative_note(tonic, tone.semitone_cnt, tone.accidental.name) }
    ref = %w[c d e f g a b]
    ref = ref.slice(ref.index(tonic[0])..-1) + ref.slice(0, ref.index(tonic[0]))

    case path
    when 'major-pentatonic', 'minor-pentatonic'
      ref.delete_if.with_index { |_note, i| path == 'major-pentatonic' ? [3, 6].include?(i) : [1, 5].include?(i) }
    when 'major-blues', 'minor-blues'
      ref.delete_if.with_index { |_note, i| path == 'major-blues' ? [3, 6].include?(i) : [1, 5].include?(i) }
      ref.insert(path == 'major-blues' ? 2 : 3, ref[path == 'major-blues' ? 2 : 3])
    when 'diminished', 'bebop-dominant'
      ref.push(ref[6])
    when 'dominant-diminished'
      ref.insert(1, ref[1])
    when 'altered'
      ref[4] = ref[3]
      ref[3] = ref[2]
      ref[2] = ref[1]
    else
      return notes unless (1..4).include?(scale_category_id)
    end

    accidentals = tones.map(&:accidental).map(&:name)
    adjust_accidentals(notes, accidentals, ref)
  end

  def self.calc_relative_note(tonic, semitone_cnt, accidental)
    notes = if %w[c csharp d dsharp e fsharp g gsharp a asharp b].include?(tonic)
              CHROMATIC_NOTES_SHARP.slice(CHROMATIC_NOTES_SHARP.index(tonic)..-1) + CHROMATIC_NOTES_SHARP.slice(0, CHROMATIC_NOTES_SHARP.index(tonic))
            elsif %w[dflat eflat f gflat aflat bflat].include?(tonic)
              CHROMATIC_NOTES_FLAT.slice(CHROMATIC_NOTES_FLAT.index(tonic)..-1) + CHROMATIC_NOTES_FLAT.slice(0, CHROMATIC_NOTES_FLAT.index(tonic))
            elsif tonic == 'esharp'
              %w[esharp fsharp g gsharp a asharp b c csharp d dsharp e]
            elsif tonic == 'bsharp'
              %w[bsharp csharp d dsharp e f fsharp g gsharp a asharp b]
            elsif tonic == 'fflat'
              %w[fflat f gflat g aflat a bflat b c dflat d eflat]
            else
              %w[cflat c dflat d eflat e f gflat g aflat a bflat]
            end

    note = notes[semitone_cnt]

    if accidental == 'sharp'
      note = if note.include?('sharp')
               note.gsub('sharp', 'doublesharp')
             elsif note.include?('flat')
               note.gsub('flat', 'natural')
             else
               "#{note}sharp"
             end
    elsif accidental == 'flat'
      note = if note.include?('flat')
               note.gsub('flat', 'doubleflat')
             elsif note.include?('sharp')
               note.gsub('sharp', 'natural')
             else
               "#{note}flat"
             end
    end

    note
  end

  def self.adjust_accidentals(notes, accidentals, ref)
    adjusted_notes = []
    notes.zip(accidentals).each_with_index do |(note, accidental), idx|
      adjusted_notes << (note[0] == ref[idx] ? note : adjust_accidental(note, ref[idx], accidental))
    end

    adjusted_notes
  end

  def self.adjust_accidental(note, base_alphabet, accidental)
    enharmonic_note = handle_enharmonic_note(note)
    chromatic_notes_for_calc = CHROMATIC_NOTES_SHARP.slice(CHROMATIC_NOTES_SHARP.index(enharmonic_note)..-1) +
                               CHROMATIC_NOTES_SHARP.slice(0, CHROMATIC_NOTES_SHARP.index(enharmonic_note))
    chromatic_notes_for_calc.unshift(*chromatic_notes_for_calc.pop(2))

    semitone_distance = chromatic_notes_for_calc.index(base_alphabet) - chromatic_notes_for_calc.index(enharmonic_note)

    case semitone_distance
    when 0
      accidental.present? ? "#{base_alphabet}natural" : base_alphabet
    when -1
      "#{base_alphabet}sharp"
    when -2
      "#{base_alphabet}doublesharp"
    when 1
      "#{base_alphabet}flat"
    when 2
      "#{base_alphabet}doubleflat"
    else
      note
    end
  end

  def self.handle_enharmonic_note(note)
    if note.include?('doublesharp')
      note[0] == 'b' ? 'csharp' : CHROMATIC_NOTES_SHARP[CHROMATIC_NOTES_SHARP.index(note[0]) + 2]
    elsif note.include?('doubleflat')
      note[0] == 'c' ? 'asharp' : CHROMATIC_NOTES_SHARP[CHROMATIC_NOTES_SHARP.index(note[0]) - 2]
    elsif note.include?('flat')
      note[0] == 'c' ? 'b' : CHROMATIC_NOTES_SHARP[CHROMATIC_NOTES_SHARP.index(note[0]) - 1]
    elsif note == 'esharp'
      'f'
    elsif note == 'bsharp'
      'c'
    elsif note.include?('natural')
      note[0]
    else
      note
    end
  end
end
