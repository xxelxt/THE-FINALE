import React from 'react';
import { Button, List, Popconfirm, Switch, Tag, Tooltip } from 'antd';
import { CheckOutlined, CloseOutlined } from '@ant-design/icons';

export const TodoItem = ({ todo, onTodoRemoval, onTodoToggle }) => {
  return (
    <List.Item
      actions={[
        <Tooltip
          title={todo.completed ? 'Mark as uncompleted' : 'Mark as completed'}
        >
          <Switch
            checkedChildren={<CheckOutlined />}
            unCheckedChildren={<CloseOutlined />}
            onChange={() => onTodoToggle(todo.id)}
            defaultChecked={todo.completed}
          />
        </Tooltip>,
        <Popconfirm
          title='Are you sure you want to delete?'
          onConfirm={() => {
            onTodoRemoval(todo);
          }}
        >
          <Button className='remove-todo-button' type='primary' danger>
            X
          </Button>
        </Popconfirm>,
      ]}
      className='list-item'
      key={todo.id}
    >
      <div className='todo-item'>
        <Tag color={todo.completed ? 'cyan' : 'red'} className='todo-tag'>
          {todo.name}
        </Tag>
      </div>
    </List.Item>
  );
};
