class UserCommentsListWorker < Struct.new(:opts)
  def perform
    UserCommentsList.new(opts)
  end

  def error job, exception
    p 'error', exception
  end

  def failure job
    p 'failure'
  end

  def enqueue
    p 'enqueue'
  end
end
