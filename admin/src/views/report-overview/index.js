import {
  Card,
  Col,
  DatePicker,
  Divider,
  Row,
  Select,
  Space,
  Spin,
  Table,
  Typography,
} from 'antd';
import React, { useContext, useEffect } from 'react';
import ChartWidget from '../../components/chart-widget';
import { BarChartOutlined, LineChartOutlined } from '@ant-design/icons';
import { shallowEqual, useDispatch, useSelector } from 'react-redux';
import { Link, useLocation } from 'react-router-dom';
import QueryString from 'qs';
import { ReportContext } from '../../context/report';
import {
  fetchReportOverviewCart,
  fetchReportOverviewCategories,
  fetchReportOverviewProducts,
} from '../../redux/slices/report/overview';
import { disableRefetch } from '../../redux/slices/menu';
import useDidUpdate from '../../helpers/useDidUpdate';
import moment from 'moment';
import numberToPrice from '../../helpers/numberToPrice';
import { useTranslation } from 'react-i18next';

const { Text, Title } = Typography;
const { RangePicker } = DatePicker;
const ReportOverview = () => {
  const { t } = useTranslation();
  const location = useLocation();
  const category_id = QueryString.parse(location.search, [])['?category_id'];
  const product_id = QueryString.parse(location.search, [])['?product_id'];
  const {
    date_from,
    date_to,
    by_time,
    chart,
    handleDateRange,
    options,
    handleByTime,
    chart_type,
    setChartType,
  } = useContext(ReportContext);
  const { loading, carts, products, categories } = useSelector(
    (state) => state.overviewReport,
    shallowEqual,
  );
  const { defaultCurrency } = useSelector(
    (state) => state.currency,
    shallowEqual,
  );
  const { activeMenu } = useSelector((state) => state.menu, shallowEqual);
  const dispatch = useDispatch();
  const columns = [
    {
      title: t('title'),
      dataIndex: 'title',
      key: 'title',
      // render: (text) => <a>{text}</a>,
    },
    {
      title: t('item.sold'),
      dataIndex: 'quantity',
      key: 'quantity',
    },
    {
      title: t('net.sales'),
      dataIndex: 'total_price',
      key: 'total_price',
      render: (price) =>
        numberToPrice(
          price,
          defaultCurrency?.symbol,
          defaultCurrency?.position,
        ),
    },
    {
      title: t('number.of.orders'),
      dataIndex: 'count',
      key: 'count',
    },
  ];
  const performance = [
    {
      title: t('total.earning'),
      qty: 'delivered_sum',
      percent: '5',
      price: true,
    },
    {
      title: t('number.of.orders'),
      qty: 'count',
      percent: '5',
      price: false,
    },
    {
      title: t('canceled.order.price'),
      qty: 'canceled_sum',
      percent: '5',
      price: true,
    },
    {
      title: t('total.tax'),
      qty: 'tax',
      percent: '5',
      price: true,
    },
    // {
    //   title: t('final.average'),
    //   qty: 'delivered_avg',
    //   percent: '5',
    //   price: true,
    // },
    {
      title: t('delivered.fee'),
      qty: 'delivery_fee',
      percent: '5',
      price: true,
    },
  ];

  const fetchProducts = (page, perPage) => {
    const params = {
      date_from,
      date_to,
      type: by_time,
      page,
      perPage,
    };
    dispatch(fetchReportOverviewProducts(params));
  };

  const fetchCategories = (page, perPage) => {
    const params = {
      date_from,
      date_to,
      type: by_time,
      page,
      perPage,
    };
    dispatch(fetchReportOverviewCategories(params));
  };

  const fetchOverview = (page, perPage) => {
    const params = {
      date_from,
      date_to,
      type: by_time,
      page,
      perPage,
    };
    if (category_id) params.categories = [category_id];
    if (product_id) params.products = [product_id];
    dispatch(fetchReportOverviewCart(params));
  };

  const onProductPaginationChange = (pagination) => {
    const { pageSize: perPage, current: page } = pagination;
    fetchProducts(page, perPage);
  };

  const onCategoryPaginationChange = (pagination) => {
    const { pageSize: perPage, current: page } = pagination;
    fetchProducts(page, perPage);
  };

  useEffect(() => {
    if (activeMenu.refetch) {
      fetchOverview();
      fetchProducts();
      fetchCategories();
      dispatch(disableRefetch(activeMenu));
    }
  }, [activeMenu.refetch]);

  useDidUpdate(() => {
    fetchOverview();
  }, [date_to, by_time, chart, category_id, product_id, date_from]);

  useDidUpdate(() => {
    fetchProducts();
  }, [date_to, by_time, date_from]);

  useDidUpdate(() => {
    fetchCategories();
  }, [date_to, by_time, date_from]);

  return (
    <Spin size='large' spinning={loading}>
      <Row gutter={24} className='mb-4'>
        <Col span={12}>
          <Space size='large'>
            <RangePicker
              defaultValue={[moment(date_from), moment(date_to)]}
              onChange={handleDateRange}
            />
          </Space>
        </Col>
      </Row>
      <Divider orientation='left'>Số liệu chung</Divider>
      <Row gutter={24}>
        {performance?.map((item, index) => {
          const colSpans = [5, 4, 5, 5, 5];
          return (
            <Col key={item.title} span={colSpans[index]}>
              <Link to='/report/revenue'>
                <Card>
                  <Row className='mb-5'>
                    <Col span={24}>
                      <Text>{item.title}</Text>
                    </Col>
                  </Row>
                  <Row gutter={24}>
                    <Col span={24}>
                      <Title level={2}>
                        {item.price
                          ? numberToPrice(
                              carts[item.qty],
                              defaultCurrency?.symbol,
                              defaultCurrency?.position,
                            )
                          : carts[item.qty]}
                      </Title>
                    </Col>
                  </Row>
                </Card>
              </Link>
            </Col>
          );
        })}
      </Row>
      <Row gutter={24} className='mb-2'>
        <Col span={20}>
          <Divider orientation='left'>Biểu đồ</Divider>
        </Col>
        <Col span={4}>
          <div className='d-flex'>
            <Select
              style={{ width: 100 }}
              onChange={handleByTime}
              options={options}
              defaultValue={by_time}
            />

            <Divider type='vertical' style={{ height: '100%' }} />
            <Space>
              <LineChartOutlined
                style={{
                  fontSize: '22px',
                  cursor: 'pointer',
                  color: chart_type === 'line' ? 'green' : '',
                }}
                onClick={() => setChartType('line')}
              />
              <BarChartOutlined
                style={{
                  fontSize: '22px',
                  cursor: 'pointer',
                  color: chart_type === 'bar' ? 'green' : '',
                }}
                onClick={() => setChartType('bar')}
              />
            </Space>
          </div>
        </Col>
      </Row>
      <Row gutter={24}>
        <Col span={12}>
          <Card title='Doanh thu'>
            <ChartWidget
              type={chart_type}
              series={[
                {
                  name: t('revenue'),
                  data: carts?.chart_price?.map((item) => item.delivered_sum),
                },
              ]}
              xAxis={carts?.chart_price?.map((item) => item.time)}
            />
          </Card>
        </Col>
        <Col span={12}>
          <Card title='Số đơn hàng'>
            <ChartWidget
              type={chart_type}
              series={[
                {
                  name: t('number.of.orders'),
                  data: carts?.chart_count?.map((item) => item.count),
                },
              ]}
              xAxis={carts?.chart_price?.map((item) => item.time)}
            />
          </Card>
        </Col>
      </Row>
      <Divider orientation='left'>Danh sách hàng đầu</Divider>
      <Row gutter={24}>
        <Col span={12}>
          <Card title='Danh mục hàng đầu'>
            <Table
              scroll={{ x: true }}
              onChange={onCategoryPaginationChange}
              pagination={{
                pageSize: categories?.per_page,
                page: categories?.current_page || 1,
                total: categories?.total,
                defaultCurrent: 1,
              }}
              columns={columns}
              dataSource={categories?.data}
            />
          </Card>
        </Col>
        <Col span={12}>
          <Card title='Sản phẩm hàng đầu'>
            <Table
              scroll={{ x: true }}
              onChange={onProductPaginationChange}
              pagination={{
                pageSize: products?.per_page,
                page: products?.current_page || 1,
                total: products?.total,
                defaultCurrent: 1,
              }}
              columns={columns}
              dataSource={products?.data}
            />
          </Card>
        </Col>
      </Row>
    </Spin>
  );
};

export default ReportOverview;
