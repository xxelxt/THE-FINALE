import { Skeleton } from "@mui/material";
import CategoryCard from "components/categoryCard/v1";
import { Category } from "interfaces";
import React from "react";
import { Swiper, SwiperSlide } from "swiper/react";
import cls from "./v1.module.scss";
import Link from "next/link";
import { useTranslation } from "react-i18next";
import { Navigation } from "swiper";

type Props = {
  data?: Category[];
  loading: boolean;
  parent?: string;
};

export default function ShopCategoryList({ data, loading, parent }: Props) {
  const { t } = useTranslation();
  return (
    <div className={cls.container}>
      <div
        className="container"
        style={{
          display: !loading && data?.length === 0 ? "none" : "block",
          background: "var(primary-bg)",
        }}
      >
        <Swiper
          breakpoints={{
            0: { spaceBetween: 10, slidesPerView: 2 },
            440: { spaceBetween: 10, slidesPerView: 2.5 },
            576: { spaceBetween: 10, slidesPerView: 3.5 },
            768: { spaceBetween: 10, slidesPerView: 4.5 },
            992: { spaceBetween: 10, slidesPerView: 5 },
            1200: { spaceBetween: 10, slidesPerView: 6.5 },
          }}
          className={`${cls.slider} full-width`}
          modules={[Navigation]}
          navigation
          spaceBetween={10}
        >
          {!!parent && (
            <SwiperSlide style={{ maxWidth: "max-content" }}>
              <Link href={`/shop-category/${parent}`} shallow>
                <div className={cls.card}>
                  <span className={cls.text}>{t("all")}</span>
                </div>
              </Link>
            </SwiperSlide>
          )}
          {loading
            ? Array.from(Array(10).keys()).map((item) => (
                <SwiperSlide key={item}>
                  <Skeleton variant="rectangular" className={cls.shimmer} />
                </SwiperSlide>
              ))
            : data?.map((category) => (
              <SwiperSlide key={category.id}>
                <div style={{ width: 200 }}>
                  <CategoryCard data={category} parent={parent} />
                </div>
              </SwiperSlide>

            ))}
        </Swiper>
      </div>
    </div>
  );
}
