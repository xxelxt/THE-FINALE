import { store } from 'redux/store';

export default function numberToPrice(number = 0, symbol, position) {
  const defaultCurrency = store.getState()?.currency?.defaultCurrency;
  const price = Number(number)
      .toFixed(0)
      .replace(/\B(?=(\d{3})+(?!\d))/g, ',');

  const currencySymbol = symbol || defaultCurrency?.symbol || '₫';
  const currencyPosition = position || defaultCurrency?.position || 'after';

  return currencyPosition === 'after'
      ? `${price}${currencySymbol}`
      : `${currencySymbol}${price}`;
}