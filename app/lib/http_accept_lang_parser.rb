class HttpAcceptLangParser
  
  def self.parse(language)
    locale = language.scan(/^[a-z]{2}/).first.to_sym
    Rails.logger.debug "* Locale set using accept_language to '#{locale}'"
    locale.in?(User::LANGUAGES.map(&:to_sym)) ? locale : nil
  end
  
end