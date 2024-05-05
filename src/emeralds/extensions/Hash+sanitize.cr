class Hash
  def sanitize
    self.reject { |key, value| key == "" || value == "" };
  end
end
