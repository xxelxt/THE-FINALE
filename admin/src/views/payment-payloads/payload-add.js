import React, { useEffect, useState } from 'react';
import {
  Button,
  Card,
  Col,
  Form,
  Input,
  Row,
  Select,
  Spin,
  Switch,
} from 'antd';
import { useTranslation } from 'react-i18next';
import { removeFromMenu, setRefetch } from 'redux/slices/menu';
import { batch, shallowEqual, useDispatch, useSelector } from 'react-redux';
import { toast } from 'react-toastify';
import { useNavigate } from 'react-router-dom';
import Paystack from 'assets/images/paystack.svg';
import { FaPaypal } from 'react-icons/fa';
import { SiFlutter, SiRazorpay, SiStripe } from 'react-icons/si';
import { fetchPaymentPayloads } from 'redux/slices/paymentPayload';
import { paymentPayloadService } from 'services/paymentPayload';
import paymentService from 'services/payment';
import { AsyncSelect } from 'components/async-select';
import currencyService from 'services/currency';
import i18n from 'configs/i18next';
import MediaUpload from 'components/upload';

export default function PaymentPayloadAdd() {
  const { t } = useTranslation();
  const [form] = Form.useForm();
  const [loadingBtn, setLoadingBtn] = useState(false);
  const [loading, setLoading] = useState(false);
  const [paymentList, setPaymentList] = useState([]);
  const [activePayment, setActivePayment] = useState(null);
  const { activeMenu } = useSelector((state) => state.menu, shallowEqual);
  const [image, setImage] = useState(
    activeMenu.data?.image ? [activeMenu.data?.image] : [],
  );

  const dispatch = useDispatch();
  const navigate = useNavigate();

  const onFinish = (values) => {
    delete values.payment_id;
    if (activePayment?.label === 'FlutterWave' && !image[0]) {
      toast.error(t('choose.payload.image'));
      return;
    }
    setLoadingBtn(true);
    paymentPayloadService
      .create({
        payment_id: activePayment.value,
        payload: {
          ...values,
          logo: image[0] ? image[0].name : undefined,
          paypal_currency: values.paypal_currency?.label,
          currency: values.currency?.label || values.currency,
          paypal_validate_ssl: values?.paypal_validate_ssl
            ? Number(values?.paypal_validate_ssl)
            : undefined,
          sandbox:
            typeof values?.sandbox !== 'undefined'
              ? Number(Boolean(values?.sandbox))
              : undefined,
        },
      })
      .then(() => {
        const nextUrl = 'payment-payloads';
        toast.success(t('successfully.created'));
        batch(() => {
          dispatch(removeFromMenu({ ...activeMenu, nextUrl }));
          dispatch(fetchPaymentPayloads({}));
          dispatch(setRefetch(activeMenu));
        });
        navigate(`/${nextUrl}`);
      })
      .catch((err) => {
        toast.dismiss();
        toast.error(err?.response?.data?.params?.payment_id[0]);
      })
      .finally(() => setLoadingBtn(false));
  };

  async function fetchPayment() {
    setLoading(true);
    return paymentService
      .getAll()
      .then(({ data }) => {
        const body = data
          .filter((item) => item.tag !== 'wallet')
          .filter((item) => item.tag !== 'cash')
          .map((item) => ({
            label: item.tag[0].toUpperCase() + item.tag.substring(1),
            value: item.id,
            key: item.id,
          }));
        setPaymentList(body);
      })
      .finally(() => setLoading(false));
  }

  useEffect(() => {
    fetchPayment();
  }, []);

  return (
    <Card title={t('add.payment.payloads')} className='h-100'>
      <Form
        layout='vertical'
        name='user-address'
        form={form}
        onFinish={onFinish}
      >
        <Row gutter={12}>
          <Col
            span={
              activePayment?.label === 'Cash' ||
              activePayment?.label === 'Wallet'
                ? 12
                : 24
            }
          >
            <Form.Item
              label={t('payment.services')}
              name='payment_id'
              rules={[
                {
                  required: true,
                  message: t('required'),
                },
              ]}
            >
              <Select
                notFoundContent={loading ? <Spin size='small' /> : 'no results'}
                allowClear
                options={paymentList}
              />
            </Form.Item>
          </Col>

        </Row>
        <div className='flex-grow-1 d-flex flex-column justify-content-end'>
          <div className='pb-5'>
            <Button
              type='primary'
              htmlType='submit'
              loading={loadingBtn}
              disabled={loadingBtn}
            >
              {t('submit')}
            </Button>
          </div>
        </div>
      </Form>
    </Card>
  );
}
