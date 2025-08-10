export const numberToPrice = (number: number, digits: number) => {
  if (number) {
    // return number.toFixed(digits).replace(/\d(?=(\d{3})+\.)/g, "$&,");
    return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
  }
  return "0";
};
