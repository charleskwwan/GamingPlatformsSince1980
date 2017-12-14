public interface TransitionValue {
  public float getCurrent();
  public float getFinal();
  public void setFinal(float finalValue);
}

public static class TransitionValues {
  private static final ArrayList<TValue> values = new ArrayList<TValue>();
  
  private class TValue implements TransitionValue  {
    private float currentValue, finalValue;
    
    private TValue(float initialValue, float finalValue) {
      this.currentValue = initialValue;
      setFinal(finalValue); // adds this to values for ticking
    }
    
    public float getCurrent() {
      return this.currentValue;
    }
    
    public float getFinal() {
      return this.finalValue;
    }
    
    public void setFinal(float finalValue) {
      this.finalValue = finalValue;
      TransitionValues.values.add(this); // need to tick again
    }
    
    private void tick() {
      if (abs(this.finalValue - this.currentValue) < 0.1) {
        this.currentValue = this.finalValue;
      } else {
        this.currentValue += (this.finalValue - this.currentValue) * .1;
      }
    }
  }
  
  public static TransitionValue add(float initialValue, float finalValue) {
    return new TransitionValues().new TValue(initialValue, finalValue);
  }
  
  public static void tick() {
    for (int i = TransitionValues.values.size()-1; i >= 0; i--) {
      TValue value = TransitionValues.values.get(i);
      value.tick();
      if (value.getCurrent() == value.getFinal())
        TransitionValues.values.remove(i);
    }
  }
}