import { Button, Card, Divider, Space, Table, Tag } from 'antd';
import React, { useEffect, useRef, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { useNavigate, useParams } from 'react-router-dom';
import orderService from 'services/order';
import { shallowEqual, useDispatch, useSelector } from 'react-redux';
import moment from 'moment';
import numberToPrice from 'helpers/numberToPrice';
import { PrinterOutlined } from '@ant-design/icons';
import { useReactToPrint } from 'react-to-print';
import { useQueryParams } from 'helpers/useQueryParams';
import useDidUpdate from 'helpers/useDidUpdate';
import Loading from './loading';
import { disableRefetch } from '../redux/slices/menu';

const calculateProductPrice = (row) => {
  return (
    ((row?.origin_price ?? 0) +
      row?.addons?.reduce((acc, cur) => (acc += cur?.origin_price ?? 0), 0)) /
    (row?.quantity ?? 1)
  );
};

const calculateProductTotalPrice = (row) => {
  return (
    (row?.total_price ?? 0) +
    row?.addons?.reduce((acc, cur) => (acc += cur?.origin_price ?? 0), 0)
  );
};

const Check = () => {
  const { t } = useTranslation();
  const { id } = useParams();
  const queryParams = useQueryParams();
  const componentRef = useRef();
  const navigate = useNavigate();
  const dispatch = useDispatch();

  const { activeMenu } = useSelector((state) => state.menu, shallowEqual);
  const { settings } = useSelector((state) => state.globalSettings);
  const { defaultCurrency } = useSelector(
    (state) => state.currency,
    shallowEqual,
  );

  const [loading, setLoading] = useState(false);
  const [data, setData] = useState(null);

  const columns = [
    {
      title: t('id'),
      dataIndex: 'stock',
      key: 'stock',
      render: (stock) => stock?.id,
    },
    {
      title: t('product'),
      dataIndex: 'stock',
      key: 'stock',
      render: (stock, row) => (
        <Space wrap>
          <span>
            {stock?.product?.translation?.title ||
              stock?.product?.id ||
              t('N/A')}
          </span>
          <span>
            {stock?.extras?.map((extra) => (
              <Tag key={extra?.id}>{extra?.value}</Tag>
            ))}
          </span>
          {row?.addons?.map((addon) => (
            <Tag key={addon?.id}>
              {`${addon?.stock?.product?.translation?.title} x ${addon?.quantity ?? 1}`}
            </Tag>
          ))}
        </Space>
      ),
    },
    {
      title: t('price'),
      dataIndex: 'origin_price',
      key: 'origin_price',
      render: (_, row) => (
        <p style={{ width: 'max-content' }}>
          {numberToPrice(calculateProductPrice(row), defaultCurrency?.symbol)}
        </p>
      ),
    },
    {
      title: t('quantity'),
      dataIndex: 'quantity',
      key: 'quantity',
      render: (quantity, row) => (
        <p
          style={{ width: 'max-content' }}
        >{`${quantity} ${row?.stock?.product?.unit?.translation?.title}`}</p>
      ),
    },
    {
      title: t('tax'),
      dataIndex: 'tax',
      key: 'tax',
      render: (tax) => (
        <p style={{ width: 'max-content' }}>
          {numberToPrice(tax, defaultCurrency?.symbol)}
        </p>
      ),
    },
    {
      title: t('total.onboard'),
      dataIndex: 'total_price',
      key: 'total_price',
      render: (_, row) => (
        <p style={{ width: 'max-content' }}>
          {numberToPrice(
            calculateProductTotalPrice(row),
            defaultCurrency?.symbol,
          )}
        </p>
      ),
    },
  ];

  useEffect(() => {
    fetchOrder();
    // eslint-disable-next-line
  }, []);

  useDidUpdate(() => {
    if (activeMenu.refetch) {
      fetchOrder();
    }
  }, [activeMenu.refetch]);

  useDidUpdate(() => {
    if (!loading && queryParams.get('print') === 'true') {
      handlePrint();
    }
  }, [id, queryParams]);

  function fetchOrder() {
    setLoading(true);
    orderService
      .getById(id)
      .then(({ data }) => {
        setData(data);
      })
      .finally(() => {
        setLoading(false);
        dispatch(disableRefetch(activeMenu));
      });
  }

  const handlePrint = useReactToPrint({
    content: () => componentRef.current,
    onAfterPrint: () => {
      if (queryParams.get('print') === 'true') {
        queryParams.set('print', false);
      }
    },
  });

  return (
    <Card
      title={t('invoice')}
      extra={
        <Space wrap>
          <Button
            type='primary'
            onClick={() => {
              if (queryParams?.get('print')) {
                navigate(-2);
              } else {
                navigate(-1);
              }
            }}
          >
            <span className='ml-1'>{t('back')}</span>
          </Button>
          <Button type='primary' onClick={() => handlePrint()}>
            <PrinterOutlined type='printer' />
            <span className='ml-1'>{t('print')}</span>
          </Button>
        </Space>
      }
    >
      {loading ? (
        <Loading />
      ) : (
        <div className='container_check' ref={componentRef}>
          <header className='check_header'>
            <div
              style={{
                objectFit: 'contain',
                maxWidth: 200,
                maxHeight: 200,
                overflow: 'hidden',
              }}
            >
              <img
                src={settings?.favicon}
                alt='img'
                className='check_icon overflow-hidden rounded'
                width={120}
                height={120}
              />
            </div>
            <h2>HOÁ ĐƠN BÁN HÀNG</h2>
            <span className='check_companyInfo'>
              <h2 style={{ marginBottom: '4px', lineHeight: '1.2' }}>
                {settings?.title}
              </h2>
              <h4 style={{ marginBottom: '4px', lineHeight: '1.2' }}>
                {settings?.address}
              </h4>
              <h4 style={{ marginBottom: '4px', lineHeight: '1.2' }}>
                {t('phone')}: {data?.shop?.phone}
              </h4>
            </span>
          </header>
          <main>
            <span>
              <h4>
                {t('order.id')}: {data?.id}
              </h4>

              <address>
                <div className='d-flex' style={{ gap: '200px' }}>
                  {/* Left Column */}
                  <div className='d-flex flex-column' style={{ gap: '10px' }}>
                    {!!data?.created_at && (
                      <span>
                        {t('created.at')}:{' '}
                        {moment(data?.created_at).format('YYYY-MM-DD')}
                      </span>
                    )}
                    <span>
                      {t('delivery.type')}: {data?.delivery_type}
                    </span>
                    {!!data?.table && (
                      <span>
                        {t('table')}: {data?.table?.name || t('N/A')}
                      </span>
                    )}
                    {!!data?.address?.address && (
                      <span>
                        {t('delivery.address')}: {data?.address?.address}
                      </span>
                    )}
                  </div>

                  {/* Right Column */}
                  <div className='d-flex flex-column' style={{ gap: '10px' }}>
                    {!!data?.delivery_date_time && (
                      <span>
                        {`${t('delivery.date')}: ${data?.delivery_date || ''}
              ${data?.delivery_time || ''}`}
                      </span>
                    )}
                    <span>
                      {t('delivery.fee')}: {numberToPrice(data?.delivery_fee)}
                    </span>
                    <span>
                      {t('tax')}: {numberToPrice(data?.tax)}
                    </span>
                    {/*<span>*/}
                    {/*  {t('status')}: <Tag color='green'>{data?.status}</Tag>*/}
                    {/*</span>*/}
                    {/*<span>*/}
                    {/*  {t('otp')}: {data?.otp ?? t('N/A')}*/}
                    {/*</span>*/}
                  </div>
                </div>
              </address>
            </span>
          </main>
          <Table
            scroll={{ x: true }}
            columns={columns}
            dataSource={data?.details || []}
            loading={loading}
            rowKey={(record) => record.id}
            pagination={false}
            className='check_table'
            bordered
            style={{ marginLeft: '50px', marginRight: '50px' }}
          />
          <footer style={{ display: 'flex', justifyContent: 'end' }}>
            <span>
              <div
                className='price-row'
                style={{
                  display: 'flex',
                  justifyContent: 'space-between',
                  alignItems: 'center',
                  gap: '40px',
                  marginBottom: '10px',
                }}
              >
                <span>{t('origin.price')}</span>
                <h4 style={{ margin: 0 }}>
                  {numberToPrice(data?.origin_price, defaultCurrency?.symbol)}
                </h4>
              </div>

              {data?.delivery_fee && (
                <div
                  className='price-row'
                  style={{
                    display: 'flex',
                    justifyContent: 'space-between',
                    alignItems: 'center',
                    gap: '40px',
                    marginBottom: '10px',
                  }}
                >
                  <span>{t('delivery.fee')}</span>
                  <h4 style={{ margin: 0 }}>
                    {numberToPrice(data?.delivery_fee, defaultCurrency?.symbol)}
                  </h4>
                </div>
              )}

              {data?.service_fee && (
                <div
                  className='price-row'
                  style={{
                    display: 'flex',
                    justifyContent: 'space-between',
                    alignItems: 'center',
                    gap: '40px',
                    marginBottom: '10px',
                  }}
                >
                  <span>{t('service.fee')}</span>
                  <h4 style={{ margin: 0 }}>
                    {numberToPrice(data?.service_fee, defaultCurrency?.symbol)}
                  </h4>
                </div>
              )}

              {data?.tax && (
                <div
                  className='price-row'
                  style={{
                    display: 'flex',
                    justifyContent: 'space-between',
                    alignItems: 'center',
                    gap: '40px',
                    marginBottom: '10px',
                  }}
                >
                  <span>{t('tax')}</span>
                  <h4 style={{ margin: 0 }}>
                    {numberToPrice(data?.tax, defaultCurrency?.symbol)}
                  </h4>
                </div>
              )}

              {!!data?.tips && (
                <div
                  className='price-row'
                  style={{
                    display: 'flex',
                    justifyContent: 'space-between',
                    alignItems: 'center',
                    gap: '40px',
                    marginBottom: '10px',
                  }}
                >
                  <span>{t('tips')}</span>
                  <h4 style={{ margin: 0 }}>
                    {numberToPrice(data?.tips, defaultCurrency?.symbol)}
                  </h4>
                </div>
              )}

              {!!data?.coupon_price && (
                <div
                  className='price-row'
                  style={{
                    display: 'flex',
                    justifyContent: 'space-between',
                    alignItems: 'center',
                    gap: '40px',
                    marginBottom: '10px',
                  }}
                >
                  <span>{t('coupon')}</span>
                  <h4 style={{ margin: 0 }}>
                    {numberToPrice(data?.coupon_price, defaultCurrency?.symbol)}
                  </h4>
                </div>
              )}

              {data?.total_discount && (
                <div
                  className='price-row'
                  style={{
                    display: 'flex',
                    justifyContent: 'space-between',
                    alignItems: 'center',
                    gap: '40px',
                    marginBottom: '10px',
                  }}
                >
                  <span>{t('total.discount')}</span>
                  <h4 style={{ margin: 0 }}>
                    {numberToPrice(
                      data?.total_discount,
                      defaultCurrency?.symbol,
                    )}
                  </h4>
                </div>
              )}

              <Divider />

              <div
                className='price-row'
                style={{
                  display: 'flex',
                  justifyContent: 'space-between',
                  alignItems: 'center',
                  gap: '40px',
                }}
              >
                <span>{t('total.price')}</span>
                <h3 style={{ margin: 0 }}>
                  {numberToPrice(data?.total_price, defaultCurrency?.symbol)}
                </h3>
              </div>
            </span>
          </footer>
          {/*<section className='text-center'>*/}
          {/*  © {moment(new Date()).format('YYYY')} {settings?.title}.{' '}*/}
          {/*  {t('all.rights.reserved')}*/}
          {/*</section>*/}
        </div>
      )}
    </Card>
  );
};

export default Check;
