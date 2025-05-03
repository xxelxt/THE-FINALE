import {
  Button,
  Card,
  Col,
  DatePicker,
  Row,
  Space,
  Spin,
  Table,
  Typography,
} from 'antd';
import React, { useContext, useEffect, useMemo, useState } from 'react';
import { CloudDownloadOutlined } from '@ant-design/icons';
import { ReportContext } from '../../context/report';
import { shallowEqual, useDispatch, useSelector } from 'react-redux';
import {
  fetchReportRevenue,
  fetchReportRevenueChart,
} from '../../redux/slices/report/revenue';
import useDidUpdate from '../../helpers/useDidUpdate';
import QueryString from 'qs';
import { useLocation } from 'react-router-dom';
import { disableRefetch } from '../../redux/slices/menu';
import moment from 'moment';
import ReportService from '../../services/reports';
import FilterColumns from '../../components/filter-column';
import numberToPrice from '../../helpers/numberToPrice';
import ReportChart from '../../components/report/chart';
import { t } from 'i18next';

const { Title, Text } = Typography;
const { RangePicker } = DatePicker;

const ReportRevenue = () => {
  const location = useLocation();
  const category_id = QueryString.parse(location.search, [])['?category_id'];
  const product_id = QueryString.parse(location.search, [])['?product_id'];
  const { date_from, date_to, by_time, chart, handleDateRange, handleChart } =
    useContext(ReportContext);
  const dispatch = useDispatch();
  const [downloadLoading, setDownloadLoading] = useState(false);

  const { activeMenu } = useSelector((state) => state.menu, shallowEqual);
  const { defaultCurrency } = useSelector(
    (state) => state.currency,
    shallowEqual,
  );
  const { loading, revenueList, chartData } = useSelector(
    (state) => state.revenueReport,
    shallowEqual,
  );
  const [columns, setColumns] = useState([
    {
      title: t('date'),
      dataIndex: 'time',
      key: 'time',
      is_show: true,
      sorter: (a, b) => moment(a.time).unix() - moment(b.time).unix(),
    },
    {
      title: t('item.sold'),
      dataIndex: 'count',
      key: 'count',
      is_show: true,
      sorter: (a, b) => a.count - b.count,
    },
    {
      title: t('number.of.orders'),
      dataIndex: 'total_quantity',
      key: 'total_quantity',
      is_show: true,
      sorter: (a, b) => a.total_quantity - b.total_quantity,
    },
    {
      title: t('delivery.fee'),
      key: 'delivery_fee',
      dataIndex: 'delivery_fee',
      render: (_, row) =>
        numberToPrice(
          row.delivery_fee,
          defaultCurrency?.symbol,
          defaultCurrency?.position,
        ),
      is_show: true,
      sorter: (a, b) => a.delivery_fee - b.delivery_fee,
    },
    {
      title: t('canceled.order.price'),
      key: 'canceled_sum',
      dataIndex: 'canceled_sum',
      render: (_, row) =>
        numberToPrice(
          row.canceled_sum,
          defaultCurrency?.symbol,
          defaultCurrency?.position,
        ),
      is_show: true,
      sorter: (a, b) => a.canceled_sum - b.canceled_sum,
    },
    {
      title: t('total.earned'),
      key: 'total_price',
      dataIndex: 'total_price',
      render: (_, row) =>
        numberToPrice(
          row.total_price,
          defaultCurrency?.symbol,
          defaultCurrency?.position,
        ),
      is_show: true,
      sorter: (a, b) => a.total_price - b.total_price,
    },
    {
      title: t('tax'),
      key: 'tax',
      dataIndex: 'tax',
      render: (_, row) =>
        numberToPrice(
          row.tax,
          defaultCurrency?.symbol,
          defaultCurrency?.position,
        ),
      is_show: true,
      sorter: (a, b) => a.tax - b.tax,
    },
  ]);
  const fetchReport = () => {
    const params = {
      date_from,
      date_to,
      type: by_time,
      chart,
    };
    if (category_id) params.categories = [category_id];
    if (product_id) params.products = [product_id];
    if (performance.find((item) => item.value === chart)) {
      dispatch(fetchReportRevenueChart(params));
    }
  };
  const fetchRevenue = () => {
    const params = {
      date_from,
      date_to,
      type: by_time,
    };
    if (category_id) params.categories = [category_id];
    if (product_id) params.products = [product_id];
    dispatch(fetchReportRevenue(params));
  };

  const excelExport = () => {
    setDownloadLoading(true);
    ReportService.getRevenueReport({
      date_from,
      date_to,
      type: by_time,
      export: 'excel',
    })
      .then((res) => {
        const body = res.data.link;
        if (body) {
          window.location.href = body;
        }
      })
      .finally(() => setDownloadLoading(false));
  };

  const performance = useMemo(
    () => [
      {
        label: t('item.sold'),
        value: 'avg_quantity',
        qty: 'quantity',
        price: false,
      },
      {
        label: t('net.sales'),
        value: 'price',
        qty: 'price',
        price: true,
      },
      // {
      //   label: t('avg.order.price'),
      //   value: 'avg_price',
      //   qty: 'avg_price',
      //   price: true,
      // },
      {
        label: t('orders'),
        value: 'count',
        qty: 'count',
        price: false,
      },
    ],
    [],
  );

  useEffect(() => {
    if (performance.every((item) => item.value !== chart)) {
      handleChart(performance[0].value);
    }
  }, []);

  useEffect(() => {
    if (activeMenu.refetch) {
      fetchRevenue();
      fetchReport();
      dispatch(disableRefetch(activeMenu));
    }
  }, [activeMenu.refetch]);

  useDidUpdate(() => {
    fetchRevenue();
  }, [date_to, by_time, chart, category_id, product_id, date_from]);

  useDidUpdate(() => {
    fetchReport();
  }, [date_to, by_time, chart, date_from]);

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
      <Row gutter={24} className='report-products'>
        {performance?.map((item, key) => (
          <Col
            span={8}
            key={item.label}
            onClick={() => handleChart(item.value)}
          >
            <Card className={chart === item.value && 'active'}>
              <Row className='mb-5'>
                <Col>
                  <Text>{item.label}</Text>
                </Col>
              </Row>
              <Row gutter={24}>
                <Col span={18}>
                  <Title level={2}>
                    {!item.price
                      ? chartData[item.qty]
                      : numberToPrice(
                          chartData[item.qty],
                          defaultCurrency?.symbol,
                          defaultCurrency?.position,
                        )}
                  </Title>
                </Col>
              </Row>
            </Card>
          </Col>
        ))}
      </Row>
      <ReportChart reportData={chartData} chart_data='quantities_sum' />
      <Card>
          <Space className='align-items-center justify-content-between mb-4 w-100'>
            <Title level={2} className='mb-0'>
              {t('revenue')}
            </Title>
            <Space align='end'>
              <Button
                onClick={excelExport}
                loading={downloadLoading}
                icon={<CloudDownloadOutlined />}
              >
                Tải về
              </Button>
              <FilterColumns columns={columns} setColumns={setColumns} />
            </Space>
          </Space>
        <Table
          columns={columns?.filter((item) => item.is_show)}
          loading={loading}
          dataSource={revenueList?.paginate}
        />
      </Card>
    </Spin>
  );
};

export default ReportRevenue;
