import { Card, Col, Form, Row, Switch } from 'antd';
import React, { useState } from 'react';
import { useTranslation } from 'react-i18next';
import { shallowEqual, useDispatch, useSelector } from 'react-redux';
import { toast } from 'react-toastify';
import settingService from 'services/settings';
import { fetchSettings as getSettings } from 'redux/slices/globalSettings';
import { CheckOutlined, CloseOutlined } from '@ant-design/icons';
import useDemo from 'helpers/useDemo';
import useDebounce from 'helpers/useDebounce';
import useDidUpdate from 'helpers/useDidUpdate';

const Permission = () => {
  const { t } = useTranslation();
  const { isDemo } = useDemo();
  const [form] = Form.useForm();
  const dispatch = useDispatch();

  const { activeMenu } = useSelector((state) => state.menu, shallowEqual);

  const [loadingBtn, setLoadingBtn] = useState(false);
  // const [inputValue, setInputValue] = useState({
  //   orderAutoRemove: 0,
  // });
  const [splitMin, setSplitMin] = useState();
  const [splitMax, setSplitMax] = useState();
  // const debounceOrderAutoRemove = useDebounce(
  //   inputValue?.orderAutoRemove,
  //   1000,
  // );
  const debounceSplitMin = useDebounce(splitMin, 1000);
  const debounceSplitMax = useDebounce(splitMax, 1000);

  // useDidUpdate(() => {
  //   if (debounceOrderAutoRemove?.toString()?.length) {
  //     updateSettings({ order_auto_remove: debounceOrderAutoRemove });
  //   }
  //   // eslint-disable-next-line react-hooks/exhaustive-deps
  // }, [debounceOrderAutoRemove]);

  useDidUpdate(() => {
    if (debounceSplitMin || debounceSplitMin === 0) {
      updateSettings({ split_min: debounceSplitMin });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [debounceSplitMin]);

  useDidUpdate(() => {
    if (debounceSplitMax || debounceSplitMax === 0) {
      updateSettings({ split_max: debounceSplitMax });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [debounceSplitMax]);

  function updateSettings(data) {
    setLoadingBtn(true);
    settingService
      .update(data)
      .then(() => {
        toast.success(t('successfully.updated'));
        dispatch(getSettings());
      })
      .finally(() => setLoadingBtn(false));
  }

  return (
    <Form
      layout='vertical'
      form={form}
      name='global-settings'
      initialValues={{
        ...activeMenu.data,
        active_parcel: Number(activeMenu.data?.active_parcel),
        auto_print_order: Number(activeMenu.data?.auto_print_order),
      }}
    >
      <Card title={t('permission')}>
        <Row gutter={24}>
          <Col span={24}>
            <Row gutter={24}>
              <Col span={12}>
                <b>{t('system.refund')}</b>
                <p>
                  {t('Lựa chọn bật chức năng hoàn tiền của hệ thống hay không')}
                </p>
              </Col>
              <Col
                span={12}
                className='mt-3'
                style={{
                  display: 'flex',
                  justifyContent: 'end',
                }}
              >
                <Form.Item name='system_refund' valuePropName='checked'>
                  <Switch
                    checkedChildren={<CheckOutlined />}
                    unCheckedChildren={<CloseOutlined />}
                    loading={loadingBtn}
                    onChange={(e) => updateSettings({ system_refund: e })}
                  />
                </Form.Item>
              </Col>
            </Row>
          </Col>
          <Col span={24}>
            <Row gutter={24}>
              <Col span={12}>
                <b>{t('order.auto.approved')}</b>
                <p>
                  {t(
                    'Lựa chọn bật tính năng tự động xác nhận đơn hàng hay không',
                  )}
                </p>
              </Col>
              <Col
                span={12}
                className='mt-3'
                style={{
                  display: 'flex',
                  justifyContent: 'end',
                }}
              >
                <Form.Item name='order_auto_approved' valuePropName='checked'>
                  <Switch
                    checkedChildren={<CheckOutlined />}
                    unCheckedChildren={<CloseOutlined />}
                    loading={loadingBtn}
                    onChange={(e) => updateSettings({ order_auto_approved: e })}
                  />
                </Form.Item>
              </Col>
            </Row>
          </Col>
          <Col span={24}>
            <Row gutter={24}>
              <Col span={12}>
                <b>{t('parcel.order.auto.approved')}</b>
                <p>
                  {t(
                    'Lựa chọn bật tính năng tự động xác nhận kiện hàng hay không',
                  )}
                </p>
              </Col>
              <Col
                span={12}
                className='mt-3'
                style={{
                  display: 'flex',
                  justifyContent: 'end',
                }}
              >
                <Form.Item
                  name='parcel_order_auto_approved'
                  valuePropName='checked'
                >
                  <Switch
                    checkedChildren={<CheckOutlined />}
                    unCheckedChildren={<CloseOutlined />}
                    loading={loadingBtn}
                    onChange={(e) =>
                      updateSettings({ parcel_order_auto_approved: e })
                    }
                  />
                </Form.Item>
              </Col>
            </Row>
          </Col>
          <Col span={24}>
            <Row gutter={24}>
              <Col span={12}>
                <b>{t('refund.delete')}</b>
                <p>
                  {t(
                    'Lựa chọn bật hiển thị nút hoàn tiền trên toàn hệ thống hay không',
                  )}
                </p>
              </Col>
              <Col
                span={12}
                className='mt-3'
                style={{
                  display: 'flex',
                  justifyContent: 'end',
                }}
              >
                <Form.Item name='refund_delete' valuePropName='checked'>
                  <Switch
                    checkedChildren={<CheckOutlined />}
                    unCheckedChildren={<CloseOutlined />}
                    loading={loadingBtn}
                    onChange={(e) => updateSettings({ refund_delete: e })}
                  />
                </Form.Item>
              </Col>
            </Row>
          </Col>
          <Col span={24}>
            <Row gutter={24}>
              <Col span={12}>
                <b>{t('order.auto.deliveryMan')}</b>
                <p>
                  {t(
                    'Lựa chọn tự động chỉ định người giao hàng cho đơn hàng hay không',
                  )}
                </p>
              </Col>
              <Col
                span={12}
                className='mt-3'
                style={{
                  display: 'flex',
                  justifyContent: 'end',
                }}
              >
                <Form.Item
                  name='order_auto_delivery_man'
                  valuePropName='checked'
                >
                  <Switch
                    checkedChildren={<CheckOutlined />}
                    unCheckedChildren={<CloseOutlined />}
                    loading={loadingBtn}
                    onChange={(e) =>
                      updateSettings({ order_auto_delivery_man: e })
                    }
                  />
                </Form.Item>
              </Col>
            </Row>
          </Col>
          <Col span={24}>
            <Row gutter={24}>
              <Col span={12}>
                <b>{t('blog.active')}</b>
                <p>{t('Lựa chọn bật tính năng blog hay không')}</p>
              </Col>
              <Col
                span={12}
                className='mt-3'
                style={{
                  display: 'flex',
                  justifyContent: 'end',
                }}
              >
                <Form.Item name='blog_active' valuePropName='checked'>
                  <Switch
                    checkedChildren={<CheckOutlined />}
                    unCheckedChildren={<CloseOutlined />}
                    loading={loadingBtn}
                    onChange={(e) => updateSettings({ blog_active: e })}
                  />
                </Form.Item>
              </Col>
            </Row>
          </Col>
          <Col span={24}>
            <Row gutter={24}>
              <Col span={12}>
                <b>{t('prompt.email.modal')}</b>
                <p>{t('Gửi tin tới những người đăng ký email')}</p>
              </Col>
              <Col
                span={12}
                className='mt-3'
                style={{
                  display: 'flex',
                  justifyContent: 'end',
                }}
              >
                <Form.Item name='prompt_email_modal' valuePropName='checked'>
                  <Switch
                    checkedChildren={<CheckOutlined />}
                    unCheckedChildren={<CloseOutlined />}
                    loading={loadingBtn}
                    onChange={(e) => updateSettings({ prompt_email_modal: e })}
                  />
                </Form.Item>
              </Col>
            </Row>
          </Col>
          <Col span={24}>
            <Row gutter={24}>
              <Col span={12}>
                <b>{t('referral.active')}</b>
                <p>{t('Lựa chọn tính năng giới thiệu hoạt động hay không')}</p>
              </Col>
              <Col
                span={12}
                className='mt-3'
                style={{
                  display: 'flex',
                  justifyContent: 'end',
                }}
              >
                <Form.Item name='referral_active' valuePropName='checked'>
                  <Switch
                    checkedChildren={<CheckOutlined />}
                    unCheckedChildren={<CloseOutlined />}
                    loading={loadingBtn}
                    onChange={(e) => updateSettings({ referral_active: e })}
                  />
                </Form.Item>
              </Col>
            </Row>
          </Col>
          <Col span={24}>
            <Row gutter={24}>
              <Col span={12}>
                <b>{t('aws.active')}</b>
                <p>{t('Lựa chọn sử dụng dịch vụ AWS để lưu ảnh hay không')}</p>
              </Col>
              <Col
                span={12}
                className='mt-3'
                style={{
                  display: 'flex',
                  justifyContent: 'end',
                }}
              >
                <Form.Item name='aws' valuePropName='checked'>
                  <Switch
                    checkedChildren={<CheckOutlined />}
                    unCheckedChildren={<CloseOutlined />}
                    loading={loadingBtn}
                    disabled={isDemo}
                    onChange={(e) => updateSettings({ aws: e })}
                  />
                </Form.Item>
              </Col>
            </Row>
          </Col>
          <Col span={24}>
            <Row gutter={24}>
              <Col span={12}>
                <b>{t('by.subscription')}</b>
                <p>
                  {t(
                    'Lựa chọn chức năng đăng ký thuê bao (subscription) hoạt động hay không',
                  )}
                </p>
              </Col>
              <Col
                span={12}
                className='mt-3'
                style={{
                  display: 'flex',
                  justifyContent: 'end',
                }}
              >
                <Form.Item name='by_subscription' valuePropName='checked'>
                  <Switch
                    checkedChildren={<CheckOutlined />}
                    unCheckedChildren={<CloseOutlined />}
                    loading={loadingBtn}
                    disabled={isDemo}
                    onChange={(e) => updateSettings({ by_subscription: e })}
                  />
                </Form.Item>
              </Col>
            </Row>
          </Col>
          <Col span={24}>
            <Row gutter={24}>
              <Col span={12}>
                <b>{t('group.order')}</b>
                <p>{t('Lựa chọn bật tính năng đặt đơn nhóm hay không')}</p>
              </Col>
              <Col
                span={12}
                className='mt-3'
                style={{
                  display: 'flex',
                  justifyContent: 'end',
                }}
              >
                <Form.Item name='group_order' valuePropName='checked'>
                  <Switch
                    checkedChildren={<CheckOutlined />}
                    unCheckedChildren={<CloseOutlined />}
                    loading={loadingBtn}
                    disabled={isDemo}
                    onChange={(e) => updateSettings({ group_order: e })}
                  />
                </Form.Item>
              </Col>
            </Row>
          </Col>
          <Col span={24}>
            <Row gutter={24}>
              <Col span={12}>
                <b>{t('reservation_enable_for_user')}</b>
                <p>{t('Lựa chọn bật tính năng đặt bàn trước hay không')}</p>
              </Col>
              <Col
                span={12}
                className='mt-3'
                style={{
                  display: 'flex',
                  justifyContent: 'end',
                }}
              >
                <Form.Item
                  name='reservation_enable_for_user'
                  valuePropName='checked'
                >
                  <Switch
                    checkedChildren={<CheckOutlined />}
                    unCheckedChildren={<CloseOutlined />}
                    loading={loadingBtn}
                    disabled={isDemo}
                    onChange={(e) =>
                      updateSettings({ reservation_enable_for_user: e })
                    }
                  />
                </Form.Item>
              </Col>
            </Row>
          </Col>
          <Col span={24}>
            <Row gutter={24}>
              <Col span={12}>
                <b>{t('is_demo')}</b>
                <p>{t('Lựa chọn bật chế độ demo hay không')}</p>
              </Col>
              <Col
                span={12}
                className='mt-3'
                style={{
                  display: 'flex',
                  justifyContent: 'end',
                }}
              >
                <Form.Item name='is_demo' valuePropName='checked'>
                  <Switch
                    checkedChildren={<CheckOutlined />}
                    unCheckedChildren={<CloseOutlined />}
                    loading={loadingBtn}
                    onChange={(e) => updateSettings({ is_demo: e })}
                  />
                </Form.Item>
              </Col>
            </Row>
          </Col>
          <Col span={24}>
            <Row gutter={24}>
              <Col span={12}>
                <b>{t('activate.parcel.mode')}</b>
                <p>
                  {t('Lựa chọn bật tính năng giao nhận kiện hàng hay không')}
                </p>
              </Col>
              <Col
                span={12}
                className='mt-3'
                style={{
                  display: 'flex',
                  justifyContent: 'end',
                }}
              >
                <Form.Item name='active_parcel' valuePropName='checked'>
                  <Switch
                    checkedChildren={<CheckOutlined />}
                    unCheckedChildren={<CloseOutlined />}
                    loading={loadingBtn}
                    onChange={(e) => {
                      updateSettings({ active_parcel: e });
                    }}
                  />
                </Form.Item>
              </Col>
            </Row>
          </Col>
          <Col span={24}>
            <Row gutter={24}>
              <Col span={12}>
                <b>{t('auto.approve.products')}</b>
                <p>
                  {t('Lựa chọn tính năng tự động duyệt sản phẩm mới hay không')}
                </p>
              </Col>
              <Col
                span={12}
                className='mt-3'
                style={{
                  display: 'flex',
                  justifyContent: 'end',
                }}
              >
                <Form.Item name='product_auto_approve' valuePropName='checked'>
                  <Switch
                    checkedChildren={<CheckOutlined />}
                    unCheckedChildren={<CloseOutlined />}
                    loading={loadingBtn}
                    onChange={(e) => {
                      updateSettings({ product_auto_approve: e });
                    }}
                  />
                </Form.Item>
              </Col>
            </Row>
          </Col>
          <Col span={24}>
            <Row gutter={24}>
              <Col span={12}>
                <b>{t('auto.approve.categories')}</b>
                <p>
                  {t('Lựa chọn tính năng tự động duyệt danh mục mới hay không')}
                </p>
              </Col>
              <Col
                span={12}
                className='mt-3'
                style={{
                  display: 'flex',
                  justifyContent: 'end',
                }}
              >
                <Form.Item name='category_auto_approve' valuePropName='checked'>
                  <Switch
                    checkedChildren={<CheckOutlined />}
                    unCheckedChildren={<CloseOutlined />}
                    loading={loadingBtn}
                    onChange={(e) => {
                      updateSettings({ category_auto_approve: e });
                    }}
                  />
                </Form.Item>
              </Col>
            </Row>
          </Col>
          <Col span={24}>
            <Row gutter={24}>
              <Col span={12}>
                <b>{t('require.phone.for.create.order')}</b>
                <p>
                  {t(
                    'Lựa chọn yêu cầu nhập số điện thoại để đặt hàng hay không',
                  )}
                </p>
              </Col>
              <Col
                span={12}
                className='mt-3'
                style={{
                  display: 'flex',
                  justifyContent: 'end',
                }}
              >
                <Form.Item
                  name='before_order_phone_required'
                  valuePropName='checked'
                >
                  <Switch
                    checkedChildren={<CheckOutlined />}
                    unCheckedChildren={<CloseOutlined />}
                    loading={loadingBtn}
                    onChange={(e) => {
                      updateSettings({ before_order_phone_required: e });
                    }}
                  />
                </Form.Item>
              </Col>
            </Row>
          </Col>
          <Col span={24}>
            <Row gutter={24}>
              <Col span={12}>
                <b>{t('driver_can_edit_credentials')}</b>
                <p>
                  {t(
                    'Lựa chọn người tài xế có thể sửa thông tin của mình hay không',
                  )}
                </p>
              </Col>
              <Col
                span={12}
                className='mt-3'
                style={{
                  display: 'flex',
                  justifyContent: 'end',
                }}
              >
                <Form.Item
                  name='driver_can_edit_credentials'
                  valuePropName='checked'
                >
                  <Switch
                    checkedChildren={<CheckOutlined />}
                    unCheckedChildren={<CloseOutlined />}
                    loading={loadingBtn}
                    onChange={(e) => {
                      updateSettings({ driver_can_edit_credentials: e });
                    }}
                  />
                </Form.Item>
              </Col>
            </Row>
          </Col>
          <Col span={24}>
            <Row gutter={24}>
              <Col span={12}>
                <b>{t('auto.print.order')}</b>
                <p>{t('Lựa chọn tự động in đơn hàng khi đã xác nhận đơn')}</p>
              </Col>
              <Col
                span={12}
                className='mt-3'
                style={{
                  display: 'flex',
                  justifyContent: 'end',
                }}
              >
                <Form.Item name='auto_print_order' valuePropName='checked'>
                  <Switch
                    checkedChildren={<CheckOutlined />}
                    unCheckedChildren={<CloseOutlined />}
                    loading={loadingBtn}
                    onChange={(e) => {
                      updateSettings({ auto_print_order: e });
                    }}
                  />
                </Form.Item>
              </Col>
            </Row>
          </Col>
          {/*<Col span={24}>*/}
          {/*  <Row gutter={24}>*/}
          {/*    <Col span={12}>*/}
          {/*      <b>{t('order.auto.remove')}</b>*/}
          {/*      <p>{t('Auto.removing.order')}</p>*/}
          {/*    </Col>*/}
          {/*    <Col span={12} className='mt-3'>*/}
          {/*      <Form.Item*/}
          {/*        name='order_auto_remove'*/}
          {/*        rules={[{ required: true, message: t('required') }]}*/}
          {/*      >*/}
          {/*        <InputNumber*/}
          {/*          onChange={(e) =>*/}
          {/*            setInputValue((prev) => {*/}
          {/*              return {*/}
          {/*                ...prev,*/}
          {/*                orderAutoRemove: e,*/}
          {/*              };*/}
          {/*            })*/}
          {/*          }*/}
          {/*          className='w-100'*/}
          {/*        />*/}
          {/*      </Form.Item>*/}
          {/*    </Col>*/}
          {/*  </Row>*/}
          {/*</Col>*/}
          {/*<Col span={24}>*/}
          {/*  <Row gutter={24}>*/}
          {/*    <Col span={12}>*/}
          {/*      <b>{t('split.min')}</b>*/}
          {/*      <p>{t('split.min.description')}</p>*/}
          {/*    </Col>*/}
          {/*    <Col span={12} className='mt-3'>*/}
          {/*      <Form.Item name='split_min'>*/}
          {/*        <InputNumber*/}
          {/*          min={0}*/}
          {/*          className='w-100'*/}
          {/*          onChange={(e) => setSplitMin(e)}*/}
          {/*        />*/}
          {/*      </Form.Item>*/}
          {/*    </Col>*/}
          {/*  </Row>*/}
          {/*</Col>*/}
          {/*<Col span={24}>*/}
          {/*  <Row gutter={24}>*/}
          {/*    <Col span={12}>*/}
          {/*      <b>{t('split.max')}</b>*/}
          {/*      <p>{t('split.max.description')}</p>*/}
          {/*    </Col>*/}
          {/*    <Col span={12} className='mt-3'>*/}
          {/*      <Form.Item name='split_max'>*/}
          {/*        <InputNumber*/}
          {/*          min={0}*/}
          {/*          className='w-100'*/}
          {/*          onChange={(e) => setSplitMax(e)}*/}
          {/*        />*/}
          {/*      </Form.Item>*/}
          {/*    </Col>*/}
          {/*  </Row>*/}
          {/*</Col>*/}
        </Row>
      </Card>
    </Form>
  );
};

export default Permission;
