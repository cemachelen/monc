module errorhandling_mod


integer, parameter :: ERR_None = 0, &
                      ERR_Default = 1, &
                      ERR_DivideByZero = 2, &
                      ERR_FileNotFound = 3, &
                      ERR_SomethingTerrible = 4

type :: ErrorType
    integer :: Code
    character(len=256) :: Message
end type

contains
  ! Error.fpp

  ! Macros for error handling.
  ! Enables user to store errors and exit the subroutine in single statement.
  ! Fortran preprocessor must be enabled: -fpp.

  ! Raise Error
  ! Store the error code and info (only if the current code is zero).
  ! Return from the subroutine.
  subroutine RAISE_ERROR(msg, error)
    interger :: error
    character(len=256) :: msg
    if (error%Code == ERR_None) then;
      error = ErrorType(Code=ERR_Default, Message=msg);
    end if
    return
  end subroutine RAISE_ERROR
  ! Pass Error
  ! Returns if there's an error.
  subroutine HANDLE_ERROR(error)
    interger :: error
    character(len=256) :: msg
    if (error%Code /= ERR_None) then;
      call MPI_Comm_set_errhandler (MPI_COMM_WORLD, MPI_ERRORS_RETURN, error)
      return
    end if
  end subroutine HANDLE_ERROR
end module errorhandling_mod
