class ::Hash
  def deep_merge(second)
    merger = proc { |_, left, right| left.is_a?(Hash) && right.is_a?(Hash) ? left.merge(right, &merger) : right }
    self.merge(second, &merger)
  end
end
