class String
  # Detect source encoding and converting
  def fix_encoding!
    # d: {:type=>:text, :encoding=>"ISO-8859-1", :ruby_encoding=>"ISO-8859-1", :confidence=>70, :language=>"nl"}
    d = CharlockHolmes::EncodingDetector.detect(self)
    self = s.encode("UTF-8", d[:encoding], invalid: :replace, replace: "")
  end
end
