class RadioQuestion < Question
  has_many :options, :dependent => :destroy, :foreign_key => :question_id

  def with_sub_questions_in_order
    options.map(&:questions).flatten.map(&:with_sub_questions_in_order).flatten.unshift(self)
  end

  def report_data
    return [] if no_answers?
    options.map { |option| [option.content, option.report_data] }
  end

  private

  def no_answers?
    answers.select { |answer| answer.response.complete? }.blank?
  end
end
