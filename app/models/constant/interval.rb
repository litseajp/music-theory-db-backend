class Constant::Interval < ApplicationRecord
  def self.generate_relative_notes(intervals, tonic)
    ref_notes = if %w[c csharp d dsharp e fsharp g gsharp a asharp b].include?(tonic)
                  CHROMATIC_NOTES_SHARP.slice(CHROMATIC_NOTES_SHARP.index(tonic)..-1) +
                    CHROMATIC_NOTES_SHARP.slice(0, CHROMATIC_NOTES_SHARP.index(tonic))
                elsif %w[dflat eflat f gflat aflat bflat].include?(tonic)
                  CHROMATIC_NOTES_FLAT.slice(CHROMATIC_NOTES_FLAT.index(tonic)..-1) +
                    CHROMATIC_NOTES_FLAT.slice(0, CHROMATIC_NOTES_FLAT.index(tonic))
                elsif tonic == 'esharp'
                  %w[esharp fsharp g gsharp a asharp b c csharp d dsharp e]
                elsif tonic == 'bsharp'
                  %w[bsharp csharp d dsharp e f fsharp g gsharp a asharp b]
                elsif tonic == 'fflat'
                  %w[fflat f gflat g aflat a bflat b c dflat d eflat]
                else
                  %w[cflat c dflat d eflat e f gflat g aflat a bflat]
                end

    ref_alphabets = %w[c d e f g a b]
    ref_alphabets = ref_alphabets.slice(ref_alphabets.index(tonic[0])..-1) + ref_alphabets.slice(0, ref_alphabets.index(tonic[0]))

    intervals.map { |interval| adjust_alphabet(ref_notes[interval.semitone_distance], ref_alphabets[interval.alphabet_distance]) }
  end

  def self.adjust_alphabet(note, base_alphabet)
    enharmonic_note = handle_enharmonic_note(note)
    chromatic_notes_for_calc = CHROMATIC_NOTES_SHARP.slice(CHROMATIC_NOTES_SHARP.index(enharmonic_note)..-1) +
                               CHROMATIC_NOTES_SHARP.slice(0, CHROMATIC_NOTES_SHARP.index(enharmonic_note))
    chromatic_notes_for_calc.unshift(*chromatic_notes_for_calc.pop(2))

    semitone_distance = chromatic_notes_for_calc.index(base_alphabet) - chromatic_notes_for_calc.index(enharmonic_note)

    case semitone_distance
    when 0
      base_alphabet
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
    else
      note
    end
  end
end
